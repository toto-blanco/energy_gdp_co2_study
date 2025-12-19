# 📋 Méthodologie Détaillée

## Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Phase 1 : Collecte des données](#phase-1--collecte-des-données)
3. [Phase 2 : Nettoyage et préparation](#phase-2--nettoyage-et-préparation)
4. [Phase 3 : Architecture de données](#phase-3--architecture-de-données)
5. [Phase 4 : Transformation avec dbt](#phase-4--transformation-avec-dbt)
6. [Phase 5 : Tests de qualité](#phase-5--tests-de-qualité)
7. [Phase 6 : Visualisation et analyse](#phase-6--visualisation-et-analyse)
8. [Choix techniques et justifications](#choix-techniques-et-justifications)

---

## Vue d'ensemble

### Objectif du projet

Ce projet vise à répondre à une question centrale : **Peut-on découpler la croissance économique des émissions de CO₂ ?** Pour y répondre, nous avons construit un pipeline de données complet analysant 64 ans de données énergétiques, environnementales et économiques pour plus de 200 pays.

### Approche méthodologique

Nous avons adopté une approche **ELT (Extract, Load, Transform)** moderne plutôt que ETL classique, en utilisant :
- **PostgreSQL** comme entrepôt de données central
- **dbt** pour les transformations SQL en tant que code versionné
- **Power BI** pour l'analyse exploratoire et la visualisation

Cette approche permet une meilleure traçabilité, testabilité et maintenabilité du pipeline.

---

## Phase 1 : Collecte des données

### Sources sélectionnées

Nous avons identifié 6 sources de données complémentaires couvrant différents aspects de notre problématique :

| Source | Type de données | Justification | Volumétrie |
|--------|-----------------|---------------|------------|
| **Our World in Data (OWID)** | Énergie primaire, électricité, CO₂ | Dataset consolidé et harmonisé, métadonnées riches | ~80k lignes |
| **World Bank** | PIB, population, urbanisation | Source de référence pour indicateurs macro | ~50k lignes |
| **IMF** | Dette publique, croissance | Données financières gouvernementales | ~30k lignes |
| **BP Statistical Review** | Production énergétique détaillée | Précision sur le mix énergétique | ~40k lignes |
| **IEA** | Capacités installées, efficacité | Données techniques sur infrastructures | ~25k lignes |
| **Global Carbon Project** | Émissions CO₂ par secteur | Granularité sectorielle (transport, industrie) | ~25k lignes |

### Critères de sélection

1. **Couverture temporelle** : Au minimum 20 ans de données historiques
2. **Couverture géographique** : Minimum 150 pays représentés
3. **Fiabilité** : Sources institutionnelles reconnues
4. **Licence** : Données ouvertes ou usage académique autorisé
5. **Format** : API disponible ou exports CSV structurés

### Méthode d'extraction

**Téléchargement manuel des fichiers CSV** depuis les portails officiels :

```python
# Exemple : Chargement des fichiers CSV téléchargés
import pandas as pd

# Chargement World Bank
df_worldbank = pd.read_csv('data/raw/worldbank_indicators.csv')

# Chargement OWID
df_owid = pd.read_csv('data/raw/owid_energy_data.csv')

# Chargement IMF
df_imf = pd.read_csv('data/raw/imf_debt_data.csv')
```

**Processus de collecte** :
1. Identification des datasets pertinents sur chaque portail
2. Téléchargement des fichiers CSV/Excel depuis les interfaces web
3. Stockage dans `data/raw/` avec nomenclature standardisée
4. Documentation des URLs sources dans `data/README_sources.md`

**Défis rencontrés** :
- Formats hétérogènes (CSV, Excel avec plusieurs onglets)
- Encodages différents (UTF-8, ISO-8859-1, Windows-1252)
- Noms de colonnes incohérents entre sources
- Structures de fichiers variables (wide vs long format)

---

## Phase 2 : Nettoyage et préparation

### 2.1 Standardisation des identifiants pays

**Problème** : Les sources utilisent différentes conventions pour nommer les pays :
- "United States" vs "USA" vs "United States of America"
- "Türkiye" vs "Turkey"
- Codes ISO-2, ISO-3, ou noms complets

**Solution** : Mapping manuel vers un référentiel unique (ISO-3) :

```python
# Dictionnaire de normalisation (extrait)
country_mapping = {
    'United States': 'USA',
    'United States of America': 'USA',
    'US': 'USA',
    'Türkiye': 'TUR',
    'Turkey': 'TUR',
    # ... 200+ entrées
}

df['country_code'] = df['country_name'].map(country_mapping)
```

**Validation** : Vérification manuelle des 50 pays les plus fréquents.

### 2.2 Gestion des valeurs manquantes

**Stratégies adoptées** (par type de variable) :

| Type de variable | Stratégie | Justification |
|------------------|-----------|---------------|
| **Séries temporelles continues** (ex: PIB) | Interpolation linéaire | Évolution progressive attendue |
| **Indicateurs structurels** (ex: superficie) | Forward fill | Valeur stable dans le temps |
| **Données récentes manquantes** | Imputation par régression | Prédiction à partir de variables corrélées |
| **Données historiques manquantes** | Suppression de la ligne | Risque élevé de biais si imputation |

**Exemple : Interpolation temporelle**

```python
# Interpolation pour le PIB (valeurs manquantes < 5 ans consécutifs)
df_sorted = df.sort_values(['country_code', 'year'])
df_sorted['gdp'] = df_sorted.groupby('country_code')['gdp'].transform(
    lambda x: x.interpolate(method='linear', limit=5)
)
```

**Taux de complétude final** :
- Variables clés (PIB, population, CO₂) : > 95%
- Variables secondaires : > 85%

### 2.3 Détection et traitement des outliers

**Méthode** : Z-score avec seuils adaptés par variable

```python
from scipy import stats

# Exemple : Détection outliers sur consommation d'énergie per capita
z_scores = np.abs(stats.zscore(df['energy_per_capita'].dropna()))
outliers = df[z_scores > 4]  # Seuil conservateur

# Investigation manuelle : vérifier si erreur de saisie ou cas réel
```

**Cas réels conservés** :
- Qatar : Consommation énergétique/capita extrême (industrie gazière)
- Islande : 100% électricité renouvelable (géothermie)

**Corrections appliquées** :
- Conversion d'unités erronées (ex: GW au lieu de MW)
- Correction de virgules mal placées (ex: 1,234,567 → 1234567)

### 2.4 Normalisation des unités

**Standardisation appliquée** :

| Variable | Unité source | Unité cible | Conversion |
|----------|--------------|-------------|------------|
| Énergie primaire | Diverses (TWh, EJ, Mtep) | TWh | Facteurs de conversion IEA |
| CO₂ | MtCO₂, GtCO₂ | MtCO₂ | ×1000 si Gt |
| PIB | Monnaies locales | USD constants 2015 | Déflateurs World Bank |
| Population | Millions, unités | Unités | ×1e6 si millions |

---

## Phase 3 : Architecture de données

### 3.1 Choix du modèle en étoile

**Justification** :
- ✅ **Simplicité des requêtes** : Jointures simples pour analyses BI
- ✅ **Performance** : Optimisé pour agrégations (SUM, AVG sur faits)
- ✅ **Compréhensibilité** : Accessible aux analystes métier
- ❌ **Redondance** : Acceptée au profit de la performance

**Alternatives considérées** :
- **Modèle en flocon** : Rejeté (complexité excessive pour bénéfice limité)
- **Data Vault** : Rejeté (overkill pour un projet analytique pur)

### 3.2 Conception des dimensions

#### dim_country

**Granularité** : 1 ligne = 1 pays

**Choix de design** :
- Clé surrogate (`country_key`) plutôt que clé naturelle (ISO-3) pour flexibilité
- Inclusion de métadonnées géographiques (lat/lon) pour cartographie
- Type SCD0 (pas d'historisation) : attributs géographiques stables

**Colonnes** :
```sql
CREATE TABLE dim_country (
    country_key SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    iso_code CHAR(3) UNIQUE NOT NULL,
    continent VARCHAR(50),
    region VARCHAR(100),
    latitude NUMERIC(8,5),
    longitude NUMERIC(8,5),
    land_area_km2 INTEGER,
    is_oil_producer BOOLEAN,
    income_group VARCHAR(50)
);
```

#### dim_time

**Granularité** : 1 ligne = 1 année

**Choix de design** :
- Clé naturelle (`year`) suffisante (pas de surrogate)
- Enrichissement avec attributs dérivés (décennie, période) pour analyses

**Colonnes** :
```sql
CREATE TABLE dim_time (
    year INTEGER PRIMARY KEY,
    decade INTEGER,  -- Ex: 2023 → 2020
    period VARCHAR(20),  -- Ex: "1960-1979", "2000-2024"
    is_leap_year BOOLEAN
);
```

### 3.3 Conception des tables de faits

#### fact_energy_environment

**Granularité** : 1 ligne = 1 pays × 1 année

**Mesures incluses** (80+ colonnes) :
- **Consommation énergétique** : Charbon, pétrole, gaz, nucléaire, renouvelables (TWh)
- **Production énergétique** : Par source (TWh)
- **Électricité** : Production, consommation, mix (%)
- **Émissions** : CO₂, GES, méthane (MtCO₂eq)
- **Intensités** : CO₂/PIB, énergie/PIB, CO₂/capita

**Additivité** :
- ✅ Consommations, émissions : Additives (SUM)
- ❌ Pourcentages, ratios : Non-additives (AVG pondéré requis)

#### fact_socio_economy

**Granularité** : 1 ligne = 1 pays × 1 année

**Mesures incluses** :
- PIB, PIB/capita (USD constants)
- Population, population urbaine
- Dette/PIB, balance commerciale
- Part de l'industrie dans le PIB

### 3.4 Relations et intégrité référentielle

**Contraintes appliquées** :

```sql
-- Clés étrangères avec cascade
ALTER TABLE fact_energy_environment
    ADD CONSTRAINT fk_country FOREIGN KEY (country_key) 
        REFERENCES dim_country(country_key) ON DELETE CASCADE,
    ADD CONSTRAINT fk_year FOREIGN KEY (year) 
        REFERENCES dim_time(year) ON DELETE CASCADE;

-- Clé primaire composite
ALTER TABLE fact_energy_environment
    ADD PRIMARY KEY (country_key, year);
```

---

## Phase 4 : Transformation avec dbt

### 4.1 Organisation du projet dbt

**Structure de dossiers** :

```
dbt/energy_projet_final/
├── models/
│   ├── staging/           # Vues brutes normalisées
│   │   ├── stg_owid.sql
│   │   ├── stg_worldbank.sql
│   │   ├── stg_imf.sql
│   │   └── ...
│   ├── dimensions/        # Tables de dimensions
│   │   ├── dim_country.sql
│   │   └── dim_time.sql
│   └── facts/             # Tables de faits
│       ├── fact_energy_environment.sql
│       └── fact_socio_economy.sql
├── tests/                 # Tests custom
├── macros/                # Fonctions réutilisables
└── dbt_project.yml
```

### 4.2 Couche staging

**Objectif** : Normaliser les sources brutes sans transformation métier

**Exemple : `stg_owid.sql`**

```sql
{{ config(materialized='view') }}

SELECT
    -- Normalisation des noms
    UPPER(TRIM(country)) AS country_code,
    year,
    
    -- Conversion d'unités
    coal_consumption * 1e6 AS coal_consumption_twh,  -- Mtoe → TWh
    
    -- Gestion des NULL
    COALESCE(co2_emissions, 0) AS co2_emissions_mt,
    
    -- Métadonnées
    CURRENT_TIMESTAMP AS _loaded_at
    
FROM {{ source('raw', 'owid_energy') }}
WHERE year BETWEEN 1960 AND 2024
    AND country_code IS NOT NULL
```

**Bonnes pratiques appliquées** :
- ✅ Matérialisée en `view` (pas de stockage, toujours à jour)
- ✅ Référence via `{{ source() }}` pour lineage
- ✅ Sélection explicite des colonnes (pas de `SELECT *`)
- ✅ Filtres de base (années valides, pays non-NULL)

### 4.3 Couche dimensions

**Exemple : `dim_country.sql`**

```sql
{{ config(
    materialized='table',
    indexes=[
        {'columns': ['iso_code'], 'unique': True}
    ]
) }}

WITH countries AS (
    SELECT DISTINCT
        country_code,
        country_name
    FROM {{ ref('stg_owid') }}
    
    UNION
    
    SELECT DISTINCT
        country_code,
        country_name
    FROM {{ ref('stg_worldbank') }}
),

enriched AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY country_name) AS country_key,
        country_name,
        country_code AS iso_code,
        -- Jointure avec métadonnées géographiques
        geo.continent,
        geo.latitude,
        geo.longitude,
        geo.land_area_km2
    FROM countries c
    LEFT JOIN {{ ref('stg_geo_metadata') }} geo
        ON c.country_code = geo.iso_code
)

SELECT * FROM enriched
```

**Stratégies clés** :
- `UNION` pour déduplication entre sources
- `ROW_NUMBER()` pour génération de clés surrogates
- Enrichissement via jointures

### 4.4 Couche facts

**Exemple : `fact_energy_environment.sql`**

```sql
{{ config(
    materialized='incremental',
    unique_key=['country_key', 'year'],
    on_schema_change='sync_all_columns'
) }}

WITH base AS (
    SELECT
        dc.country_key,
        dt.year,
        
        -- Énergie
        owid.coal_consumption_twh,
        owid.oil_consumption_twh,
        owid.gas_consumption_twh,
        owid.nuclear_consumption_twh,
        owid.renewables_consumption_twh,
        
        -- Calcul de l'énergie primaire totale
        COALESCE(owid.coal_consumption_twh, 0) +
        COALESCE(owid.oil_consumption_twh, 0) +
        COALESCE(owid.gas_consumption_twh, 0) +
        COALESCE(owid.nuclear_consumption_twh, 0) +
        COALESCE(owid.renewables_consumption_twh, 0) AS primary_energy_twh,
        
        -- Émissions
        owid.co2_emissions_mt,
        bp.methane_emissions_mt,
        
        -- Calcul d'intensités
        CASE 
            WHEN fe.gdp > 0 THEN owid.co2_emissions_mt / fe.gdp * 1e6
            ELSE NULL
        END AS co2_intensity_kg_per_usd
        
    FROM {{ ref('stg_owid') }} owid
    INNER JOIN {{ ref('dim_country') }} dc
        ON owid.country_code = dc.iso_code
    INNER JOIN {{ ref('dim_time') }} dt
        ON owid.year = dt.year
    LEFT JOIN {{ ref('stg_bp') }} bp
        ON dc.iso_code = bp.country_code 
        AND dt.year = bp.year
    LEFT JOIN {{ ref('fact_socio_economy') }} fe
        ON dc.country_key = fe.country_key 
        AND dt.year = fe.year
)

SELECT * FROM base

{% if is_incremental() %}
    WHERE year > (SELECT MAX(year) FROM {{ this }})
{% endif %}
```

**Points clés** :
- **Incremental model** : Ne recharge que les nouvelles années
- **Calculs métier** : Intensités, totaux, parts relatives
- **Jointures complexes** : Enrichissement multi-sources
- **Gestion des NULL** : `COALESCE` systématique

### 4.5 Macros réutilisables

**Exemple : Calcul de pourcentages sûr**

```sql
-- macros/safe_percentage.sql
{% macro safe_percentage(numerator, denominator) %}
    CASE 
        WHEN {{ denominator }} > 0 THEN 
            ({{ numerator }}::NUMERIC / {{ denominator }}::NUMERIC) * 100
        ELSE NULL
    END
{% endmacro %}

-- Usage dans un modèle
{{ safe_percentage('renewables_consumption', 'primary_energy') }} AS renewables_pct
```

---

## Phase 5 : Tests de qualité

### 5.1 Tests génériques dbt

**Configuration dans `schema.yml`** :

```yaml
models:
  - name: fact_energy_environment
    columns:
      - name: energy_key
        tests:
          - unique
          - not_null
      
      - name: country_key
        tests:
          - not_null
          - relationships:
              to: ref('dim_country')
              field: country_key
      
      - name: year
        tests:
          - not_null
          - relationships:
              to: ref('dim_time')
              field: year
      
      - name: co2_emissions_mt
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
              inclusive: true
```

### 5.2 Tests custom

**Test : Cohérence énergétique**

```sql
-- tests/assert_energy_balance.sql
SELECT
    country_key,
    year,
    primary_energy_twh,
    (coal_consumption_twh + oil_consumption_twh + 
     gas_consumption_twh + nuclear_consumption_twh + 
     renewables_consumption_twh) AS sum_components,
    ABS(primary_energy_twh - sum_components) AS difference
FROM {{ ref('fact_energy_environment') }}
WHERE ABS(primary_energy_twh - sum_components) > 1  -- Tolérance 1 TWh
```

**Test : Pourcentages valides**

```sql
-- tests/assert_valid_percentages.sql
SELECT *
FROM {{ ref('fact_energy_environment') }}
WHERE renewables_pct < 0 
   OR renewables_pct > 100
   OR nuclear_pct < 0 
   OR nuclear_pct > 100
```

### 5.3 Stratégie de tests

**Niveaux de tests** :

1. **Tests unitaires** (staging) : Format, NULL, types
2. **Tests d'intégration** (dims/facts) : Relations, contraintes
3. **Tests métier** (facts) : Cohérence, logique business

**Exécution** :

```bash
# Tous les tests
dbt test

# Tests d'un modèle spécifique
dbt test --select fact_energy_environment

# Tests avec warnings pour valeurs limites
dbt test --warn-error
```

---

## Phase 6 : Visualisation et analyse

### 6.1 Connexion Power BI ↔ PostgreSQL

**Configuration** :
- Mode **DirectQuery** pour données à jour en temps réel
- Requêtes optimisées avec index sur clés de jointure
- Filtres poussés au niveau SQL (query folding)

### 6.2 Mesures DAX principales

**Mesure : CO₂ Total**

```dax
CO2 Total = 
SUM(fact_energy_environment[co2_emissions_mt])
```

**Mesure : Évolution YoY**

```dax
CO2 YoY % = 
VAR CurrentYear = MAX(dim_time[year])
VAR PreviousYear = CurrentYear - 1
VAR CurrentCO2 = 
    CALCULATE([CO2 Total], dim_time[year] = CurrentYear)
VAR PreviousCO2 = 
    CALCULATE([CO2 Total], dim_time[year] = PreviousYear)
RETURN
    DIVIDE(CurrentCO2 - PreviousCO2, PreviousCO2, 0)
```

**Mesure : Ranking pays**

```dax
Rank CO2 = 
RANKX(
    ALL(dim_country),
    [CO2 Total],
    ,
    DESC,
    DENSE
)
```

### 6.3 Visualisations créées

**Page 1 : Vue d'ensemble mondiale**
- Carte choroplèthe : Émissions CO₂ par pays
- Line chart : Évolution PIB vs CO₂ (1960-2024)
- KPI cards : Total mondial, croissance YoY

**Page 2 : Mix énergétique**
- Stacked area chart : Évolution du mix par source
- Treemap : Consommation par pays et source
- Gauge : Part des renouvelables (cible 50% d'ici 2050)

**Page 3 : Découplage**
- Scatter plot : PIB/capita vs CO₂/capita (avec régression)
- Small multiples : Top 10 PIB, trajectoires individuelles
- Table : Pays ayant réussi le découplage (croissance + baisse CO₂)

---

## Choix techniques et justifications

### PostgreSQL vs alternatives

**Pourquoi PostgreSQL ?**
- ✅ Open source, gratuit
- ✅ Robuste pour OLAP (window functions, CTEs, indexes)
- ✅ Compatible dbt-core
- ✅ Neon (cloud) pour déploiement facile

**Alternatives considérées** :
- BigQuery : Coût élevé pour projet étudiant
- Snowflake : Même raison
- SQLite : Performances insuffisantes (250k+ lignes)

### dbt vs alternatives ETL

**Pourquoi dbt ?**
- ✅ Transformations en SQL (compétence réutilisable)
- ✅ Versioning Git natif
- ✅ Tests intégrés
- ✅ Documentation auto-générée
- ✅ Communauté active

**Alternatives considérées** :
- Apache Airflow : Trop complexe pour ce use case
- Talend/Pentaho : Interfaces graphiques, moins maintenable
- Scripts Python : Pas de lineage ni tests automatisés

### Power BI vs alternatives

**Pourquoi Power BI ?**
- ✅ Performances DAX excellentes
- ✅ Intégration Windows (contrainte bootcamp)
- ✅ Visualisations interactives riches

**Alternatives considérées** :
- Tableau : Licence payante
- Looker : Nécessite Google Cloud
- Metabase : Limité pour analyses avancées

---

## Limites et améliorations futures

### Limites actuelles

1. **Données manquantes pré-1990** : Nombreux pays en développement
2. **Granularité annuelle** : Pas de données mensuelles pour événements ponctuels
3. **Biais de survie** : Pays disparus (ex: URSS) difficiles à traiter
4. **Projections** : Modèles simples (régression linéaire), pas de ML avancé

### Améliorations envisagées

1. **CI/CD** : GitHub Actions pour tester automatiquement les PR
2. **Alerting** : Notifications si tests dbt échouent
3. **ML** : Modèles prédictifs (ARIMA, Prophet) pour scénarios 2030
4. **API** : Exposer le warehouse via FastAPI pour applications tierces
5. **Temps réel** : Intégrer flux IEA pour données journalières (électricité)

---

## Conclusion

Ce projet démontre la mise en œuvre d'un pipeline de données moderne end-to-end, combinant :
- **Rigueur d'ingénierie** : Tests, documentation, versioning
- **Pragmatisme** : Technologies open source, faisables en 6 semaines
- **Impact métier** : Réponses concrètes à une question sociétale majeure

Les résultats confirment que le découplage croissance/CO₂ est possible, comme le prouvent la France, le Royaume-Uni et l'Allemagne, mais nécessite une action volontariste sur le mix énergétique et l'électrification des usages.

---

*Document rédigé par : Antoine Blanc, Amy Sarr, Asia Tran, Jean-François Kowalczyk*  
*Date : Décembre 2024*  
*Version : 1.0*
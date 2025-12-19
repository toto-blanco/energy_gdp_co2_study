# 🌍 Analyse Énergétique Mondiale : Décarbonation et Croissance Économique

[![dbt](https://img.shields.io/badge/dbt-1.7-orange)](https://www.getdbt.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)](https://powerbi.microsoft.com/)
[![Python](https://img.shields.io/badge/Python-3.10-green)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

**Problématique** : Peut-on découpler la croissance économique des émissions de CO₂ ? Les énergies bas  carbone sont-elles une solution viable à grande échelle ?

Ce projet effectue une exploration approfondie des tendances énergétiques mondiales, des émissions de CO₂ et de leurs liens avec le développement économique sur une période de 64 ans (1960–2024).

---



## 🛠️ Stack Technique

| Composant | Technologie | Usage |
|-----------|-------------|-------|
| **Collecte & Nettoyage** | Python (pandas, numpy)| nettoyage 250k+ lignes |
| **Stockage** | PostgreSQL 16 (local + Neon cloud) | Raw data + warehouse OLAP |
| **Transformation** | dbt 1.7 | Pipeline ETL `raw → staging → marts` (6 stagings) |
| **Modélisation** | SQL (CTEs, window functions) | Schéma en étoile (2 dims, 2 facts) |
| **Tests Qualité** | dbt tests |
| **Visualisation** | Power BI Desktop | Dashboards interactifs (15+ visuels) |
| **Versioning** | Git + GitHub | 

---

## 📊 Architecture de Données

### Modèle en Étoile (OLAP)

```
┌─────────────────┐         ┌──────────────────────────────┐
│   dim_country   │────────▶│  fact_energy_environment     │
│                 │         │                              │
│ • country_key   │         │ • energy_key (PK)            │
│ • country_name  │         │ • country_key (FK)           │
│ • iso_code      │         │ • year (FK)                  │
│ • latitude      │         │ • coal_consumption           │
│ • longitude     │         │ • oil_consumption            │
│ • land_area     │         │ • gas_consumption            │
└─────────────────┘         │ • nuclear_consumption        │
                            │ • renewables_consumption     │
┌─────────────────┐         │ • co2_emissions              │
│    dim_time     │────────▶│ • greenhouse_gas_emissions   │
│                 │         │ • ... (80+ colonnes)         │
│ • year (PK)     │         └──────────────────────────────┘
│ • decade        │                      │
│ • period        │                      │
└─────────────────┘                      ▼
                            ┌──────────────────────────────┐
                            │   fact_socio_economy         │
                            │                              │
                            │ • economy_key (PK)           │
                            │ • country_key (FK)           │
                            │ • year (FK)                  │
                            │ • population                 │
                            │ • gdp                        │
                            │ • gdp_per_capita             │
                            │ • gdp_growth                 │
                            │ • debt_to_gdp_ratio          │
                            │ • industry_pct_gdp           │
                            │ • urban_population_pct       │
                            └──────────────────────────────┘
```

**Granularité** : Pays × Année 

---

## 📁 Structure du Projet

```
energy-analysis/
│
├── 📂 data/
│   ├── raw/                    # CSVs bruts (4 sources)
│   ├── clean/                  # CSVs nettoyés (Python)
│   └── README_sources.md       # Documentation des sources
│
├── 📂 notebooks/
│   ├── 01_nettoyage_et_transformation        
│   └── 02_exploration_verification
    └── 03_predictions
│
├── 📂 dbt/energy_projet_final/
│   ├── models/
│   │   ├── staging/            # Vues brutes normalisées (6 modèles)
│   │   ├── dimensions/         # Tables de dimensions (2 modèles)
│   │   └── facts/              # Tables de faits (2 modèles)
│   ├── tests/                  
│   ├── dbt_project.yml         # Config dbt
│   ├── profiles.yml.example    # Template connexion DB
│
├── 📂 presentations/
│   ├── energy_study.pbix                             # Fichier Power BI
│   └── energy_projet_final_statique.pptx/            # présentation avec rapport power bi statique 
│
├── 📂 docs/
│   ├── methodology.md          # Méthodologie détaillée
│   ├── glossaires              # glossaire docx des fichiers raw
    ├── shema_olap              # shema olap complet et résumé
│
├── 📂 sql/
│   └── setup_postgres.sql      # Script création DB locale
│
├── .gitignore
├── README.md                   # Ce fichier
└── LICENSE
```

---

## 🚀 Installation & Exécution

### Prérequis

- Python 3.10+
- PostgreSQL 16+ (local) **OU** compte Neon (cloud)
- dbt 1.7+
- Power BI Desktop (pour visualisation)

### 1️⃣ Cloner le repo

```bash
git clone https://github.com/ton-username/energy-analysis.git
cd energy-analysis
```

### 2️⃣ Installer les dépendances Python

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 3️⃣ Configurer PostgreSQL

**Option A : PostgreSQL local**

```bash
# Créer la base de données
psql -U postgres -c "CREATE DATABASE energy_study;"

# Charger les données brutes
psql -U postgres -d energy_astudy-f sql/setup_postgres.sql
```

**Option B : Neon (cloud, gratuit)**

1. Crée un compte sur [neon.tech](https://neon.tech)
2. Crée un projet "energy-analysis"
3. Note la connection string
4. Charge les données via `COPY` ou `pg_restore`

### 4️⃣ Configurer dbt

```bash
cd dbt/energy_projet_final

# Copier le template de config
cp profiles.yml.example ~/.dbt/profiles.yml

# Éditer avec tes credentials
nano ~/.dbt/profiles.yml
```

**Exemple de `profiles.yml` :**

```yaml
energy_projet_final:
  target: local
  outputs:
    local:
      type: postgres
      host: localhost
      port: 5432
      user: postgres
      password: your_password
      dbname: energy_study
      schema: public
      threads: 4
      
    prod:
      type: postgres
      host: your-neon-instance.neon.tech
      port: 5432
      user: your_user
      password: "{{ env_var('NEON_PASSWORD') }}"
      dbname: energy_prod
      schema: public
      threads: 8
```

### 5️⃣ Exécuter le pipeline dbt

```bash
# Installer les packages dbt
dbt deps

# Tester la connexion
dbt debug

# Exécuter les transformations (local)
dbt run --target local

# Exécuter les tests de qualité
dbt test

# Générer la documentation
dbt docs generate
dbt docs serve  # Ouvre http://localhost:8080
```

### 6️⃣ Ouvrir le dashboard Power BI

```bash
# Ouvrir le fichier
dashboards/energy_study.pbix

# Configurer la connexion à ta DB (Fichier → Options → Sources de données)
```

---

## 📈 Résultats & Analyses

### 1. Top 10 PIB : Des stratégies énergétiques divergentes

**Pays avec découplage réussi (croissance + baisse CO₂) :**
- 🇫🇷 **France** : -12% CO₂ depuis 2000 (grâce au nucléaire 40%)
- 🇬🇧 **Royaume-Uni** : -30% CO₂ (sortie du charbon, montée du gaz/éolien)
- 🇩🇪 **Allemagne** : -20% CO₂ (transition charbon → renouvelables)

**Pays en transition :**
- 🇺🇸 **États-Unis** : Substitution charbon → gaz (-10% CO₂)
- 🇨🇳 **Chine** : Stabilisation des émissions malgré croissance (solaire x50)

### 2. L'électricité comme vecteur de décarbonation

**Part d'électricité bas-carbone (nucléaire + renouvelables) :**

| Pays | 2000 | 2023 | Évolution |
|------|------|------|-----------|
| Norvège | 98% | 98% | Stable (hydro) |
| France | 88% | 90% | +2% |
| Brésil | 82% | 85% | +3% (hydro + éolien) |
| Allemagne | 25% | 58% | +33% 🚀 |
| Chine | 15% | 32% | +17% |

**Constat** : L'électrification des usages (transport, chauffage) + électricité propre = levier majeur.

### 3. Projection 2050

**Scénario "Business as usual"** : +2.5°C, PIB x2.2, CO₂ x1.5  
**Scénario "Transition"** : +1.5°C, PIB x2.2, CO₂ ÷2

**Investissement requis** : 8.5 trillions USD sur 20 ans (0.5% PIB/an)

---

## 🧪 Qualité des Données

### Tests dbt implémentés (50+)

**Tests génériques :**
- `not_null` sur toutes les clés primaires/étrangères
- `unique` sur `country_key`, `year`
- `relationships` (intégrité référentielle dims ↔ facts)

**Tests custom :**
- Valeurs positives (consommation, PIB, population)
- Cohérence énergétique : `primary_energy ≈ coal + oil + gas + nuclear + renewables`
- Parts relatives entre 0 et 100%

**Tests dbt_utils :**
- `unique_combination_of_columns` sur (`country_key`, `year`)
- `expression_is_true` pour validations métier

**Exécution :**

```bash
dbt test
# Résultat attendu : 50+ tests passed ✅
```

---

## 📚 Sources de Données

| Source | Description | Licence | URL |
|--------|-------------|---------|-----|
| **Our World in Data (OWID)** | Énergie, CO₂, électricité | CC BY 4.0 | [owid.org/energy](https://ourworldindata.org/energy) |
| **International Monetary Fund** | Dette publique, indicateurs macro | Open Data | [imf.org/data](https://www.imf.org/en/Data) |
| **World Bank** | PIB, population, urbanisation | CC BY 4.0 | [data.worldbank.org](https://data.worldbank.org/) |
| **BP Statistical Review** | Production énergétique | Open | [bp.com/energy](https://www.bp.com/en/global/corporate/energy-economics/statistical-review-of-world-energy.html) |
| **IEA** | Mix électrique détaillé | Open (partiel) | [iea.org/data](https://www.iea.org/data-and-statistics) |
| **Global Carbon Project** | Émissions CO₂ détaillées | CC BY 4.0 | [globalcarbonproject.org](https://www.globalcarbonproject.org/) |

**Période couverte** : 1960-2024 (64 ans)  
**Volume total** : 250k+ lignes (6 sources consolidées)

---

## 🧠 Méthodologie

### Pipeline complet (End-to-End)

```
┌─────────────────┐
│  1. COLLECTE    │  
│                 │  
│                 │  → APIs publiques (Kaggle,World Bank, IMF)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  2. NETTOYAGE   │  Python (pandas, numpy)
│                 │  → Normalisation noms pays (200+ pays)
│                 │  → Gestion valeurs manquantes (interpolation)
│                 │  → Standardisation formats (dates, unités)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  3. INGESTION   │  PostgreSQL
│                 │  → COPY des CSVs dans schema "raw"
│                 │  → 6 tables sources
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 4. TRANSFORM    │  dbt (SQL)
│                 │  → Staging : Nettoyage + normalisation (6 vues)
│                 │  → Dimensions : dim_country, dim_time (tables)
│                 │  → Facts : fact_energy, fact_economy (tables)
│                 │  → Tests qualité : 50+ tests automatisés
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 5. ANALYSE      │  Power BI + DAX
│                 │  → 15+ visuels interactifs
│                 │  → Mesures DAX avancées (time intelligence, rankings)
│                 │  → Cartes choroplèthes, line charts, stacked bars
└─────────────────┘
```

### Défis techniques relevés

1. **Normalisation des noms de pays** : 200+ variantes harmonisées (ex: "Türkiye" → "Turkey")
2. **Gestion des valeurs manquantes** : Interpolation temporelle pour séries continues
3. **Optimisation des performances** : Incremental models dbt pour tables massives
4. **Intégrité référentielle** : Relations strictes dims ↔ facts avec tests automatisés

---

## 📖 Documentation Complète

- 📄 **[Méthodologie détaillée](docs/methodology.md)** : Explication des choix techniques
- 📊 **[Dictionnaire de données](docs/data_dictionary.md)** : Description de chaque colonne
- 🎤 **[Présentation Demo Day](docs/presentation.pdf)** : Slides de la présentation (8 min)
- 🔗 **[Documentation dbt](https://ton-username.github.io/energy-analysis/)** : Lineage interactif

---

## 🤝 Contributions

Ce projet a été réalisé en groupe dans le cadre d'un bootcamp Data Analyst. Les contributions sont les bienvenues :

- 🐛 **Bugs** : Ouvrir une [issue](https://github.com/toto-blanco/energy_gdp_co2_study/issues)
- 💡 **Améliorations** : Fork + Pull Request

---

## 📜 Licence

Ce projet est sous licence **Creative Commons BY-NC-SA 4.0**.


**Vous êtes autorisé à** :
- ✅ Partager et adapter le code
- ✅ Utiliser à des fins éducatives/non-commerciales

**Conditions** :
- Attribution requise (citer l'auteur)
- Partage dans les mêmes conditions
- Usage commercial interdit sans autorisation

[Lire la licence complète](LICENSE)

---

## 👤 Auteur

**Antoine Blanc**
**Amy Sarr**
**Asia Tran**
**Jean_François Kowalczyk**


- 💻 [GitHub](https://github.com/toto-blanco)

---

## 🙏 Remerciements

- **Our World in Data** pour leurs datasets exhaustifs et bien documentés
- **dbt Labs** pour l'outil de transformation de données
- **Communauté PostgreSQL** pour la robustesse de la DB
- **Bootcamp [Jedha]** pour l'encadrement du projet

---

## 📌 Mots-clés

`data-analysis` `energy` `co2-emissions` `climate-change` `dbt` `postgresql` `power-bi` `etl` `data-engineering` `analytics` `python` `sql` `olap` `star-schema` `business-intelligence`

---

*Dernière mise à jour : Décembre 2025*
# 📚 Sources de Données - Projet Analyse Énergétique Mondiale

Ce document répertorie toutes les sources de données utilisées dans ce projet, avec leurs caractéristiques, licences et instructions d'accès.
Github n'acceptant pas les fichiers de plus de 100.00 MB le fichier "imf_global_debt_databse.csv" n'est pas présent dans dans le depôt Github
---

## 📊 Vue d'ensemble

| Source | Type | Période | Pays couverts | Licence | Volume |
|--------|------|---------|---------------|---------|--------|
| Kaggle (CO₂) | CSV | 1990-2022 | 195+ | CC0 Public Domain | ~45k lignes |
| Kaggle (Energie durable) | CSV | 2000-2020 | 175+ | CC BY-SA 4.0 | ~3.6k lignes |
| OWID Energy | CSV/JSON | 1965-2023 | 200+ | CC BY 4.0 | ~70k lignes |
| World Bank (Industrie) | API/CSV | 1960-2023 | 217 | CC BY 4.0 | ~12k lignes |
| World Bank (Urbanisation) | API/CSV | 1960-2023 | 217 | CC BY 4.0 | ~12k lignes |
| IMF (Dette publique) | API | 1950-2023 | 190+ | Open Data | ~15k lignes |

**Total estimé** : ~157k+ lignes de données brutes consolidées en ~6k lignes (pays × année) après nettoyage.

---

## 🔗 Sources détaillées


### 1. Kaggle - Émissions CO₂ par pays, régions et secteurs

**URL** : [https://www.kaggle.com/datasets/shreyanshdangi/co-emissions-across-countries-regions-and-sectors](https://www.kaggle.com/datasets/shreyanshdangi/co-emissions-across-countries-regions-and-sectors)

**Description** :  
Dataset Kaggle compilant les émissions de CO₂ par pays depuis 1990, avec ventilation sectorielle (énergie, transport, industrie, agriculture).

**Données extraites** :
- `co2_emissions` : Émissions totales de CO₂ (millions de tonnes)
- `co2_per_capita` : Émissions par habitant (tonnes/personne)
- `co2_from_coal`, `co2_from_oil`, `co2_from_gas` : Émissions par source fossile
- `co2_from_cement`, `co2_from_flaring` : Émissions industrielles

**Format** : CSV  
**Taille** : ~8 MB  
**Licence** : CC0 1.0 Universal (Public Domain)  
**Dernière mise à jour** : 2023  
**Qualité** : ⭐⭐⭐⭐☆ (quelques valeurs manquantes pour pays en développement)

**Accès** :
```bash
# Téléchargement via Kaggle CLI (nécessite un compte)
kaggle datasets download -d shreyanshdangi/co-emissions-across-countries-regions-and-sectors
unzip co-emissions-across-countries-regions-and-sectors.zip -d data/raw/
```

---

### 2. Kaggle - Global Data on Sustainable Energy

**URL** : [https://www.kaggle.com/datasets/anshtanwar/global-data-on-sustainable-energy](https://www.kaggle.com/datasets/anshtanwar/global-data-on-sustainable-energy)

**Description** :  
Dataset consolidé sur l'énergie durable à l'échelle mondiale, incluant production/consommation d'énergies renouvelables, accès à l'électricité, et indicateurs de développement.

**Données extraites** :
- `renewable_energy_consumption` : Consommation d'énergies renouvelables (TWh)
- `renewables_share_energy` : Part des renouvelables dans le mix énergétique (%)
- `electricity_access` : Taux d'accès à l'électricité (% population)
- `clean_cooking_access` : Accès à des moyens de cuisson propres (%)
- `renewable_electricity_capacity` : Capacité installée (GW)

**Format** : CSV  
**Taille** : ~1.2 MB  
**Licence** : CC BY-SA 4.0 (Attribution - Partage dans les mêmes conditions)  
**Dernière mise à jour** : 2021  
**Qualité** : ⭐⭐⭐⭐⭐ (données ONU/Banque Mondiale consolidées)

**Accès** :
```bash
kaggle datasets download -d anshtanwar/global-data-on-sustainable-energy
unzip global-data-on-sustainable-energy.zip -d data/raw/
```

---

### 3. Our World in Data (OWID) - Energy Dataset

**URL** : [https://github.com/owid/energy-data](https://github.com/owid/energy-data)

**Description** :  
**Source principale du projet**. Dataset exhaustif maintenu par OWID, agrégant les données de BP Statistical Review, Energy Institute, IEA, et autres sources officielles. Met à jour annuellement.

**Données extraites** (80+ colonnes) :
- **Consommation primaire** : `coal_consumption`, `oil_consumption`, `gas_consumption`, `nuclear_consumption`, `renewables_consumption` (TWh)
- **Production électrique** : `electricity_generation`, `electricity_from_*` (coal, gas, oil, nuclear, hydro, wind, solar) (TWh)
- **Émissions** : `co2`, `co2_per_capita`, `co2_per_gdp`, `greenhouse_gas_emissions` (Mt)
- **Intensités** : `energy_per_capita`, `energy_per_gdp` (kWh/$)
- **Mix énergétique** : `fossil_share_energy`, `low_carbon_share_energy` (%)

**Format** : CSV (UTF-8)  
**Taille** : ~22 MB  
**Licence** : CC BY 4.0 (Attribution requise)  
**Dernière mise à jour** : Novembre 2023  
**Qualité** : ⭐⭐⭐⭐⭐ (référence mondiale, données vérifiées)

**Accès** :
```bash
# Téléchargement direct depuis GitHub
wget https://raw.githubusercontent.com/owid/energy-data/master/owid-energy-data.csv -P data/raw/

# Ou clone du repo complet
git clone https://github.com/owid/energy-data.git
```

**Documentation** : [https://github.com/owid/energy-data/blob/master/owid-energy-codebook.csv](https://github.com/owid/energy-data/blob/master/owid-energy-codebook.csv)

---

### 4. World Bank - Industry Value Added (% of GDP)

**URL** : [https://donnees.banquemondiale.org/indicateur/NV.IND.TOTL.ZS](https://donnees.banquemondiale.org/indicateur/NV.IND.TOTL.ZS)

**Description** :  
Indicateur mesurant la part de l'industrie (manufacturière + extractive + construction) dans le PIB de chaque pays. Essentiel pour comprendre la structure économique et son impact énergétique.

**Données extraites** :
- `industry_value_added_pct_gdp` : Part de l'industrie dans le PIB (%)
- Données annuelles par pays (1960-2023)

**Format** : CSV / API JSON  
**Licence** : CC BY 4.0  
**Qualité** : ⭐⭐⭐⭐⭐ (données officielles des gouvernements)

**Accès via API Python** :
```python
import wbdata
import pandas as pd

# Code indicateur : NV.IND.TOTL.ZS
indicator = {'NV.IND.TOTL.ZS': 'industry_pct_gdp'}
df = wbdata.get_dataframe(indicator, convert_date=True)
df.to_csv('data/raw/world_bank_industry.csv')
```

**Accès via téléchargement manuel** :  
Cliquer sur "Télécharger" → Format CSV → Enregistrer dans `data/raw/`

---

### 5. IMF - Government Debt Database

**URL** : [https://data.imf.org/en/Data-Explorer?datasetUrn=IMF.FAD:GDD(2.0.0)](https://data.imf.org/en/Data-Explorer?datasetUrn=IMF.FAD:GDD(2.0.0))

**Description** :  
Base de données du FMI sur la dette publique des États. Inclut dette/PIB, déficit budgétaire, et autres indicateurs de soutenabilité fiscale. Utile pour analyser la capacité d'investissement dans la transition énergétique.

**Données extraites** :
- `debt_to_gdp_ratio` : Dette publique brute (% du PIB)
- `primary_balance` : Solde budgétaire primaire (% du PIB)
- Données annuelles par pays (1950-2023)

**Format** : CSV / API JSON / Excel  
**Licence** : Open Data (utilisation libre avec attribution)  
**Qualité** : ⭐⭐⭐⭐⭐ (source officielle gouvernements + FMI)

**Accès** :
1. Aller sur le Data Explorer IMF
2. Sélectionner "Government Debt Database (GDD)"
3. Filtrer : All countries, 1990-2023, indicateur "General government gross debt"
4. Télécharger au format CSV
5. Enregistrer dans `data/raw/imf_debt.csv`

**Note** : L'API IMF nécessite une clé (gratuite mais inscription requise).

---

## 📋 Processus de collecte

### Vérification de l'intégrité

```python
# Vérifier les fichiers téléchargés
import os

required_files = [
    "data/raw/owid_energy.csv",
    "data/raw/co2_emissions.csv",
    "data/raw/sustainable_energy.csv",
    "data/raw/world_bank_industry.csv",
    "data/raw/world_bank_urban_population.csv",
    "data/raw/imf_debt.csv"
]

for file in required_files:
    if os.path.exists(file):
        size_mb = os.path.getsize(file) / (1024 * 1024)
        print(f"✅ {file} ({size_mb:.2f} MB)")
    else:
        print(f"❌ {file} MANQUANT")
```

---

## 🧹 Nettoyage des données

Après collecte, les données brutes passent par un pipeline de nettoyage :

**Script** : [`notebooks/02_data_cleaning.ipynb`](../notebooks/02_data_cleaning.ipynb)

**Opérations principales** :
1. **Normalisation des noms de pays** : 200+ variantes harmonisées (ex: "Türkiye" → "Turkey")
2. **Gestion des valeurs manquantes** :
   - Interpolation linéaire pour séries temporelles continues
   - Suppression si >30% de valeurs manquantes pour un pays
3. **Conversion d'unités** : Standardisation en TWh, Mt CO₂, USD courants
4. **Détection d'outliers** : Z-score > 3 → investigation manuelle
5. **Validation** : Tests de cohérence (ex: somme mix énergétique ≈ 100%)

**Output** : Données nettoyées dans `data/clean/`

---

## 📊 Statistiques de couverture

### Couverture géographique

| Région | Pays dans les données | Couverture population mondiale |
|--------|----------------------|-------------------------------|
| Europe | 50 | 10% |
| Asie | 48 | 60% |
| Afrique | 54 | 17% |
| Amériques | 35 | 13% |
| Océanie | 14 | <1% |
| **TOTAL** | **201** | **99.2%** |

### Couverture temporelle

| Source | Période disponible | Période utilisée |
|--------|-------------------|------------------|
| OWID Energy | 1965-2023 | 1990-2023 |
| Kaggle CO₂ | 1990-2022 | 1990-2022 |
| Kaggle Sustainable | 2000-2020 | 2000-2020 |
| World Bank | 1960-2023 | 1990-2023 |
| IMF | 1950-2023 | 1990-2023 |

**Période d'analyse finale** : **1990-2023 (33 ans)**  
Justification : Avant 1990, données manquantes pour >30% des pays.

---

## 🔄 Fréquence de mise à jour

| Source | Fréquence officielle | Dernière mise à jour | Prochaine mise à jour |
|--------|---------------------|---------------------|----------------------|
| OWID Energy | Annuelle (juin) | Juin 2024 | Juin 2025 |
| World Bank | Annuelle (avril) | Avril 2024 | Avril 2025 |
| IMF GDD | Biannuelle | Octobre 2024 | Avril 2025 |
| Kaggle | Variable | 2023 | - |

**Note** : Les données énergétiques ont généralement 1-2 ans de décalage (temps de compilation par les agences nationales).

---

## ⚖️ Licences et attribution

### Résumé des licences

| Licence | Sources | Obligations |
|---------|---------|-------------|
| **CC BY 4.0** | OWID, World Bank | Attribution obligatoire |
| **CC BY-SA 4.0** | Kaggle Sustainable | Attribution + Partage à l'identique |
| **CC0 (Public Domain)** | Kaggle CO₂ | Aucune |
| **Open Data** | IMF | Attribution recommandée |

### Attribution requise

Lors de l'utilisation de ce projet, merci d'inclure :

```
Données énergétiques : Our World in Data (CC BY 4.0)
Données économiques : World Bank (CC BY 4.0) et IMF (Open Data)
Données CO₂ : Kaggle (CC0 et CC BY-SA 4.0)
```

**Citation complète** :
```bibtex
@dataset{owid_energy_2024,
  author = {Hannah Ritchie and Pablo Rosado and Max Roser},
  title = {Energy Data Explorer},
  year = {2024},
  publisher = {Our World in Data},
  url = {https://github.com/owid/energy-data}
}
```

---


## 📞 Support & Contact

**Questions sur les sources ?**
- OWID : [https://ourworldindata.org/about#contact](https://ourworldindata.org/about#contact)
- World Bank : [https://datahelpdesk.worldbank.org/](https://datahelpdesk.worldbank.org/)
- IMF : [data@imf.org](mailto:data@imf.org)

**Questions sur ce projet ?**
- Ouvrir une [issue GitHub](https://github.com/ton-username/energy-analysis/issues)

---

*Dernière mise à jour : Décembre 2025*
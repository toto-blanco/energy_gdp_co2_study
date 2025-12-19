BEGIN;

CREATE TABLE pourc_pop_urb_clean (
    "Country Name" text,
    "Year" integer,
    "Country Code" text,
    "Indicator Name" text,
    "Indicator Code" text,
    "UrbanPopPercent" double precision
);

COPY pourc_pop_urb_clean
FROM '/tmp/pourc_pop_urb_clean.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE data_co2_emissions_across_clean (
    "Name" text,
    "year" integer,
    "iso_code" text,
    "co2" double precision,
    "co2_growth_abs" double precision,
    "co2_growth_prct" double precision,
    "co2_per_capita" double precision,
    "co2_per_gdp" double precision,
    "coal_co2" double precision,
    "gas_co2" double precision,
    "oil_co2" double precision,
    "temperature_change_from_co2" double precision,
    "missing_count" integer
);

COPY data_co2_emissions_across_clean
FROM '/tmp/data_co2_emissions_across_clean.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE owid_energy_data_clean (
    "country" text,
    "year" integer,
    "iso_code" text,
    "population" double precision,
    "gdp" double precision,
    "coal_cons_per_capita" double precision,
    "coal_consumption" double precision,
    "coal_elec_per_capita" double precision,
    "coal_electricity" double precision,
    "coal_prod_per_capita" double precision,
    "coal_production" double precision,
    "coal_share_elec" double precision,
    "coal_share_energy" double precision,
    "electricity_demand" double precision,
    "electricity_demand_per_capita" double precision,
    "electricity_generation" double precision,
    "electricity_share_energy" double precision,
    "energy_per_capita" double precision,
    "energy_per_gdp" double precision,
    "fossil_elec_per_capita" double precision,
    "fossil_electricity" double precision,
    "fossil_energy_per_capita" double precision,
    "fossil_fuel_consumption" double precision,
    "fossil_share_elec" double precision,
    "fossil_share_energy" double precision,
    "gas_consumption" double precision,
    "gas_elec_per_capita" double precision,
    "gas_electricity" double precision,
    "gas_energy_per_capita" double precision,
    "gas_prod_per_capita" double precision,
    "gas_production" double precision,
    "gas_share_elec" double precision,
    "gas_share_energy" double precision,
    "greenhouse_gas_emissions" double precision,
    "hydro_consumption" double precision,
    "hydro_elec_per_capita" double precision,
    "hydro_electricity" double precision,
    "hydro_energy_per_capita" double precision,
    "hydro_share_elec" double precision,
    "hydro_share_energy" double precision,
    "low_carbon_consumption" double precision,
    "low_carbon_elec_per_capita" double precision,
    "low_carbon_electricity" double precision,
    "low_carbon_energy_per_capita" double precision,
    "low_carbon_share_elec" double precision,
    "low_carbon_share_energy" double precision,
    "net_elec_imports" double precision,
    "net_elec_imports_share_demand" double precision,
    "nuclear_consumption" double precision,
    "nuclear_elec_per_capita" double precision,
    "nuclear_electricity" double precision,
    "nuclear_energy_per_capita" double precision,
    "nuclear_share_elec" double precision,
    "nuclear_share_energy" double precision,
    "oil_consumption" double precision,
    "oil_elec_per_capita" double precision,
    "oil_electricity" double precision,
    "oil_energy_per_capita" double precision,
    "oil_prod_per_capita" double precision,
    "oil_production" double precision,
    "oil_share_elec" double precision,
    "oil_share_energy" double precision,
    "per_capita_electricity" double precision,
    "primary_energy_consumption" double precision,
    "renewables_consumption" double precision,
    "renewables_elec_per_capita" double precision,
    "renewables_electricity" double precision,
    "renewables_energy_per_capita" double precision,
    "renewables_share_elec" double precision,
    "renewables_share_energy" double precision,
    "solar_consumption" double precision,
    "solar_elec_per_capita" double precision,
    "solar_electricity" double precision,
    "solar_energy_per_capita" double precision,
    "solar_share_elec" double precision,
    "solar_share_energy" double precision,
    "wind_consumption" double precision,
    "wind_elec_per_capita" double precision,
    "wind_electricity" double precision,
    "wind_energy_per_capita" double precision,
    "wind_share_elec" double precision,
    "wind_share_energy" double precision
);

COPY owid_energy_data_clean
FROM '/tmp/owid-energy-data_clean.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE imf_global_debt_database_clean (
    "COUNTRY" text,
    "INDICATOR" text,
    "TIME_PERIOD" integer,
    "OBS_VALUE" double precision,
    "SCALE" text
);

COPY imf_global_debt_database_clean
FROM '/tmp/imf_global_debt_database_clean.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE global_data_on_sustainable_energy_clean (
    "Entity" text,
    "Year" integer,
    "Access to electricity (% of population)" double precision,
    "Access to clean fuels for cooking" double precision,
    "Renewable-electricity-generating-capacity-per-capita" double precision,
    "Renewable energy share in total final energy consumption (%)" double precision,
    "Electricity from fossil fuels (TWh)" double precision,
    "Electricity from nuclear (TWh)" double precision,
    "Electricity from renewables (TWh)" double precision,
    "Low-carbon electricity (% electricity)" double precision,
    "Primary energy consumption per capita (kWh/person)" double precision,
    "Value_co2_emissions_kt_by_country" double precision,
    "gdp_growth" double precision,
    "gdp_per_capita" double precision,
    "Density\n(P/Km2)" text,
    "Land Area(Km2)" double precision,
    "Latitude" double precision,
    "Longitude" double precision
);

COPY global_data_on_sustainable_energy_clean
FROM '/tmp/global-data-on-sustainable-energy_clean.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE indus_pourc_pib_clean (
    "Country Name" text,
    "Country Code" text,
    "Year" integer,
    "ratio Indus/PIB" double precision
);

COPY indus_pourc_pib_clean
FROM '/tmp/indus_pourc_pib_clean.csv'
WITH (FORMAT csv, HEADER true);

COMMIT;
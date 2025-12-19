
  create view "neondb"."public"."stg_owid_data__dbt_tmp"
    
    
  as (
    with source as (

    select
       country,
       year,
       iso_code,
       population,
       gdp,

       -- CONSOMMATION & PRODUCTION
       primary_energy_consumption,
       coal_consumption,
       oil_consumption,
       gas_consumption,
       nuclear_consumption,
       hydro_consumption,
       solar_consumption,
       wind_consumption,
       renewables_consumption,
       fossil_fuel_consumption,
       low_carbon_consumption,
       coal_production,
       oil_production,
       gas_production,

        -- ELECTRICITY
       electricity_generation,
       electricity_demand,
       net_elec_imports,
       coal_electricity,
       gas_electricity,
       oil_electricity,
       nuclear_electricity,
       hydro_electricity,
       solar_electricity,
       wind_electricity,
       renewables_electricity,
       fossil_electricity,
       low_carbon_electricity,

        -- SHARES ENERGY
       coal_share_energy,
       oil_share_energy,
       gas_share_energy,
       nuclear_share_energy,
       hydro_share_energy,
       solar_share_energy,
       wind_share_energy,
       renewables_share_energy,
       fossil_share_energy,
       low_carbon_share_energy,
       electricity_share_energy,

        -- SHARES ELECTRICITY
       coal_share_elec,
       gas_share_elec,
       oil_share_elec,
       nuclear_share_elec,
       hydro_share_elec,
       solar_share_elec,
       wind_share_elec,
       renewables_share_elec,
       fossil_share_elec,
       low_carbon_share_elec,
       net_elec_imports_share_demand,

        -- PER CAPITA
       energy_per_capita,
       energy_per_gdp,
       electricity_demand_per_capita,
       per_capita_electricity,
       coal_cons_per_capita,
       coal_elec_per_capita,
       gas_energy_per_capita,
       gas_elec_per_capita,
       oil_energy_per_capita,
       oil_elec_per_capita,
       nuclear_energy_per_capita,
       nuclear_elec_per_capita,
       hydro_energy_per_capita,
       hydro_elec_per_capita,
       solar_energy_per_capita,
       solar_elec_per_capita,
       wind_energy_per_capita,
       wind_elec_per_capita,
       renewables_energy_per_capita,
       renewables_elec_per_capita,
       fossil_energy_per_capita,
       fossil_elec_per_capita,
       low_carbon_energy_per_capita,
       low_carbon_elec_per_capita,
       coal_prod_per_capita,
       oil_prod_per_capita,
       gas_prod_per_capita,
       greenhouse_gas_emissions
    from "neondb"."energy_raw"."owid_energy_data_clean"

)


select *
from source
  );
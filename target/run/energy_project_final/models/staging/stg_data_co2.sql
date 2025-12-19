
  create view "neondb"."public"."stg_data_co2__dbt_tmp"
    
    
  as (
    with source as (

    select
        "Name" as country,
        year, 
        iso_code,
        "co2" as co2_emissions,
        co2_growth_abs,
        co2_growth_prct,
        co2_per_capita,
        co2_per_gdp,
        coal_co2,
        gas_co2,
        oil_co2,
        temperature_change_from_co2
    from "neondb"."energy_raw"."data_co2_emissions_across_clean"
)


select *
from source
  );
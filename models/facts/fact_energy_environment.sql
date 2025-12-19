with energy as (

    select *
    from {{ ref('stg_owid_data') }}

),

co2 as (

    select *
    from {{ ref('stg_data_co2') }}

),

glob as (

    select *
    from {{ ref('stg_global_data') }}

),

joined as (

    select
        ctry.country_key,
        t.year,

        e.primary_energy_consumption,
        e.coal_consumption,
        e.oil_consumption,
        e.gas_consumption,
        e.nuclear_consumption,
        e.hydro_consumption,
        e.solar_consumption,
        e.wind_consumption,
        e.renewables_consumption,
        e.fossil_fuel_consumption,
        e.low_carbon_consumption,

        e.coal_production,
        e.oil_production,
        e.gas_production,

        e.electricity_generation,
        e.electricity_demand,
        e.net_elec_imports,
        e.coal_electricity,
        e.gas_electricity,
        e.oil_electricity,
        e.nuclear_electricity,
        e.hydro_electricity,
        e.solar_electricity,
        e.wind_electricity,
        e.renewables_electricity,
        e.fossil_electricity,
        e.low_carbon_electricity,

        e.coal_share_energy,
        e.oil_share_energy,
        e.gas_share_energy,
        e.nuclear_share_energy,
        e.hydro_share_energy,
        e.solar_share_energy,
        e.wind_share_energy,
        e.renewables_share_energy,
        e.fossil_share_energy,
        e.low_carbon_share_energy,
        e.electricity_share_energy,

        e.coal_share_elec,
        e.gas_share_elec,
        e.oil_share_elec,
        e.nuclear_share_elec,
        e.hydro_share_elec,
        e.solar_share_elec,
        e.wind_share_elec,
        e.renewables_share_elec,
        e.fossil_share_elec,
        e.low_carbon_share_elec,
        e.net_elec_imports_share_demand,

        e.energy_per_gdp,
        e.energy_per_capita,
        e.electricity_demand_per_capita,
        e.per_capita_electricity,

        e.coal_cons_per_capita,
        e.coal_elec_per_capita,
        e.gas_energy_per_capita,
        e.gas_elec_per_capita,
        e.oil_energy_per_capita,
        e.oil_elec_per_capita,
        e.nuclear_energy_per_capita,
        e.nuclear_elec_per_capita,
        e.hydro_energy_per_capita,
        e.hydro_elec_per_capita,
        e.solar_energy_per_capita,
        e.solar_elec_per_capita,
        e.wind_energy_per_capita,
        e.wind_elec_per_capita,
        e.renewables_energy_per_capita,
        e.renewables_elec_per_capita,
        e.fossil_energy_per_capita,
        e.fossil_elec_per_capita,
        e.low_carbon_energy_per_capita,
        e.low_carbon_elec_per_capita,
        e.coal_prod_per_capita,
        e.oil_prod_per_capita,
        e.gas_prod_per_capita,

        co2.co2_emissions,
        co2.co2_growth_abs,
        co2.co2_growth_prct,
        co2.co2_per_capita,
        co2.co2_per_gdp,
        co2.coal_co2,
        co2.gas_co2,
        co2.oil_co2,
        co2.temperature_change_from_co2,
        e.greenhouse_gas_emissions,

        glob.access_electricity_pct,
        glob.access_clean_cooking_pct,
        glob.renewable_share_final_consumption

    from energy e
    left join co2 on e.country = co2.country and e.year = co2.year
    left join glob on e.country = glob.country and e.year = glob.year
    left join {{ ref('dim_country') }} ctry on e.country = ctry.country_name
    left join {{ ref('dim_time') }} t on e.year = t.year
)

select * from joined

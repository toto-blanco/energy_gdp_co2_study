with source as (

    select
        "Entity" as country,
        "Year" as year,
        "Access to electricity (% of population)" as access_electricity_pct,
        "Access to clean fuels for cooking" as access_clean_cooking_pct,
        "Renewable-electricity-generating-capacity-per-capita" as renewable_capacity_per_capita,
        "Renewable energy share in total final energy consumption (%)" as renewable_share_final_consumption,
        "Electricity from fossil fuels (TWh)" as fossil_electricity_twh,
        "Electricity from nuclear (TWh)" as nuclear_electricity_twh,
        "Electricity from renewables (TWh)" as renewables_electricity_twh,
        "Low-carbon electricity (% electricity)" as low_carbon_electricity_pct,
        "Primary energy consumption per capita (kWh/person)" as primary_energy_per_capita_kwh,
        "Value_co2_emissions_kt_by_country" as co2_emissions_kt,
        gdp_growth,
        gdp_per_capita,
        "Density\n(P/Km2)" as density_per_km2,
        "Land Area(Km2)" as land_area_km2,
        "Latitude" as latitude,
        "Longitude" as longitude
    from {{ source('energy_raw', 'global_data_on_sustainable_energy_clean') }}
)


select *
from source

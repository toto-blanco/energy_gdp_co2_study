with source as (

    select
        "Country Name" as country,
        "Country Code" as iso_code,
        "Year" as year,
        "ratio Indus/PIB" as industry_value_added_pct_gdp
    from {{ source('energy_raw', 'indus_pourc_pib_clean') }}

)

select *   
from source

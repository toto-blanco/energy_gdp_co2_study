with source as (

    select
        "COUNTRY" as country,
        "TIME_PERIOD" as year,
        "INDICATOR" as indicator,
        "OBS_VALUE" as value
    from {{ source('energy_raw', 'imf_global_debt_database_clean') }}

),

pivoted as (
    select
        country,
        year,

        max(case 
            when indicator = 'Debt instruments, General government, Percent of GDP'
            then value
        end) as general_government_pct_gdp,

        max(case 
            when indicator = 'Debt instruments, Private sector, Percent of GDP'
            then value
        end) as private_debt_pct_gdp

    from source
    group by 1, 2
)

select *
from pivoted

with source as (

    select
        "Country Name" as country,
        "Year" as year,
        "Country Code" as iso_code,        
        "UrbanPopPercent" as urban_population_ratio
    from "neondb"."energy_raw"."pourc_pop_urb_clean"

)

select * 
from source
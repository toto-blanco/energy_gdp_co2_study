with country_list as (

    select distinct country, iso_code
    from "neondb"."public"."stg_owid_data"
    where country is not null

),

country_details as (
    select distinct country, latitude,longitude,land_area_km2,density_per_km2
    from "neondb"."public"."stg_global_data"
    where country is not null
),

unioned as (

    select
        row_number() over (order by country) as country_key,
        cl.country as country_name,
        cl.iso_code,
        cd.latitude,
        cd.longitude,
        cd.land_area_km2,
        cd.density_per_km2
    from country_list cl
    left join country_details cd using(country)
)

select * from unioned
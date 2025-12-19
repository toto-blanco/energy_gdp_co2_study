
    
    

select
    country_key as unique_field,
    count(*) as n_records

from "neondb"."public"."dim_country"
where country_key is not null
group by country_key
having count(*) > 1



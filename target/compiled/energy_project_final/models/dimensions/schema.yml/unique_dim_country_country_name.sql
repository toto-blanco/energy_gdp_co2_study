
    
    

select
    country_name as unique_field,
    count(*) as n_records

from "neondb"."public"."dim_country"
where country_name is not null
group by country_name
having count(*) > 1



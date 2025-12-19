
    
    

select
    year as unique_field,
    count(*) as n_records

from "neondb"."public"."dim_time"
where year is not null
group by year
having count(*) > 1



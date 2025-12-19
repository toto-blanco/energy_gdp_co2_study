
    
    

select
    fact_key as unique_field,
    count(*) as n_records

from "neondb"."public"."fact_energy_environment"
where fact_key is not null
group by fact_key
having count(*) > 1



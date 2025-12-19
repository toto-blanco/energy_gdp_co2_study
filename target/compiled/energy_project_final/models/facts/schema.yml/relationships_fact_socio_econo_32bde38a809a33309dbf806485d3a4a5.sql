
    
    

with child as (
    select country_key as from_field
    from "neondb"."public"."fact_socio_economy"
    where country_key is not null
),

parent as (
    select country_key as to_field
    from "neondb"."public"."dim_country"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



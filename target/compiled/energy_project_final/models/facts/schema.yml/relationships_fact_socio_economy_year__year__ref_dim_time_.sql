
    
    

with child as (
    select year as from_field
    from "neondb"."public"."fact_socio_economy"
    where year is not null
),

parent as (
    select year as to_field
    from "neondb"."public"."dim_time"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



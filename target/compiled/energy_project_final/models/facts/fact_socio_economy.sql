with owid as (

    select country, year, population, gdp
    from "neondb"."public"."stg_owid_data"

),

glob as (

    select country, year, gdp_per_capita, gdp_growth
    from "neondb"."public"."stg_global_data"
),

indus as (

    select *
    from "neondb"."public"."stg_industry_pib"

),

urban as (

    select *
    from "neondb"."public"."stg_urban_pop"

),

imf as (

    select *
    from "neondb"."public"."stg_imf_debt"

),

joined as (

    select
        ctry.country_key,
        t.year,
        o.population,
        u.urban_population_ratio,
        o.gdp,
        g.gdp_per_capita,
        g.gdp_growth,
        i.industry_value_added_pct_gdp,
        imf.general_government_pct_gdp,
        imf.private_debt_pct_gdp

    from owid o
    left join glob g on o.country = g.country and o.year = g.year
    left join indus i on o.country = i.country and o.year = i.year
    left join urban u on o.country = u.country and o.year = u.year
    left join imf on o.country = imf.country and o.year = imf.year
    left join "neondb"."public"."dim_country" ctry on o.country = ctry.country_name
    left join "neondb"."public"."dim_time" t on o.year = t.year
)

select * from joined
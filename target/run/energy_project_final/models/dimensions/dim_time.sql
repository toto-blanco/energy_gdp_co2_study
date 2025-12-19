
  
    

  create  table "neondb"."public"."dim_time__dbt_tmp"
  
  
    as
  
  (
    select
    year,
    floor(year / 10) * 10 as decade,
    concat('20th-', year) as period
from generate_series(1950, 2024, 1) as year
  );
  
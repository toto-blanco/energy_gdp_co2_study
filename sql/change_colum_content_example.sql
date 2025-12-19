TRUNCATE <nom_table>_clean;

COPY <nom_table>_clean
FROM '/tmp/<nom_csv>_clean.csv'
WITH (FORMAT csv, HEADER true);

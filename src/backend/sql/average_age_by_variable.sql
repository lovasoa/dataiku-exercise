-- Average age by variable
-- For a given variable, return
-- its different values,
-- the number of people that have the variable set to this value
-- the average age of these people.
-- When there are more then 100 results, return the 100 first results, and
-- a last (101st) result aggregating all the other values
WITH results AS (
  SELECT
    AVG(census.age) AS age, COUNT(*) AS samples, census.value AS value
  FROM census
  WHERE census.column = ?
  GROUP BY census.value
  ORDER BY samples DESC
)
  SELECT main_results.* FROM (SELECT * FROM results LIMIT 100) AS main_results
UNION ALL
  SELECT * FROM (
      SELECT
      AVG(others.age) AS age,
      SUM(others.samples) AS samples,
      ('Other (' || COUNT(others.value) || ' distinct values)') AS value
      FROM (SELECT * FROM results LIMIT 1000000 OFFSET 100) AS others
      WHERE others.value IS NOT NULL
  )
  WHERE samples IS NOT NULL

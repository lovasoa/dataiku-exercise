-- Returns the name of a column, given its id
SELECT
  name AS column
FROM columns
WHERE id = ?

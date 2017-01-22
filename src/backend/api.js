'use strict';
const express = require('express');
const sqlite = require('sqlite');
const path = require('path')

const app = express();
const PORT = process.env.PORT || 3000;
const DB_FILE = '/census.db';
const STATIC_DIR = path.resolve(__dirname + '/../frontend/static')

console.log(`Launching application on port ${PORT}...`);
sqlite.open(__dirname + DB_FILE)
      .then(() => app.listen(PORT))
      .catch((e) => console.error(e));

// Serve our Elm application on /
app.get('/', (req, res) => res.sendFile(STATIC_DIR + '/index.html'));
app.use('/static', express.static(STATIC_DIR));

// Serve our api on /api
const data = express().get('/data/:column', function(req, res){
  const SQL_VALUES = `
    WITH results AS (
      SELECT
        AVG(census.age) AS age, COUNT(*) AS samples, census.value AS value
      FROM census
      WHERE census.column = ?
      GROUP BY census.value
      ORDER BY samples DESC
    )
      SELECT s1.* FROM (SELECT * FROM results LIMIT 100) AS s1
    UNION ALL
      SELECT * FROM (
          SELECT
          AVG(others.age) AS age,
          SUM(others.samples) AS samples,
          ('Other (' || COUNT(others.value) || 'distinct values)') AS value
          FROM (SELECT * FROM results LIMIT 100000 OFFSET 100) AS others
          WHERE others.value IS NOT NULL
      )
      WHERE samples IS NOT NULL
  `;
  const SQL_NAME = `SELECT name FROM COLUMNS WHERE id = ?`;
  sqlite.all(SQL_VALUES, [req.params.column]).then((data) =>
    res.json({data, column: req.params.column})
  ).catch((err) => res.status(500).json({'error': err}));
});
const columns = express().get('/columns', function(req, res){
  const SQL_SELECT = `SELECT id, name FROM columns`;
  sqlite.all(SQL_SELECT, [req.params.column]).then((data) =>
    res.json({data})
  ).catch((err) => res.status(500).json({'error': err}));
});
app.use('/api', data);
app.use('/api', columns);

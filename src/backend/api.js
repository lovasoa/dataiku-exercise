'use strict';
const express = require('express');
const sqlite = require('sqlite');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_FILE = '/census.db';

sqlite.open(__dirname + DB_FILE)
      .then(() => app.listen(PORT))
      .catch((e) => console.error(e));

const SQL_SELECT = `
  SELECT
    AVG(age) AS age, COUNT(*) AS samples, value
  FROM census
  WHERE column = ?
  GROUP BY value
  LIMIT 100
`;

app.get('/data/:column', function(req, res){
  sqlite.all(SQL_SELECT, [req.params.column]).then((results) =>
    res.json({
      data: results,
      column: req.params.column,
    })
  ).catch((err) => res.status(500).json({'error': err}));
});

'use strict';
const express = require('express');
const sqlite = require('sqlite');
const path = require('path')

const app = express();
const PORT = process.env.PORT || 3000;
const DB_FILE = '/census.db';
const STATIC_DIR = path.resolve(__dirname + '/../frontend/static')

sqlite.open(__dirname + DB_FILE)
      .then(() => app.listen(PORT))
      .catch((e) => console.error(e));

// Serve our Elm application on /
app.get('/', (req, res) => res.sendFile(STATIC_DIR + '/compiled-application.html'));
app.use('/static', express.static(STATIC_DIR));

// Serve our api on /api
const column = express().get('/data/:column', function(req, res){
  const SQL_SELECT = `
    SELECT
      AVG(age) AS age, COUNT(*) AS samples, value
    FROM census
    WHERE column = ?
    GROUP BY value
    LIMIT 100
  `;
  sqlite.all(SQL_SELECT, [req.params.column]).then((results) =>
    res.json({
      data: results,
      column: req.params.column,
    })
  ).catch((err) => res.status(500).json({'error': err}));
});
app.use('/api', column);

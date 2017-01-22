'use strict';
const express = require('express');
const sqlite = require('sqlite');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_FILE = '/census.db';
const STATIC_DIR = path.resolve(__dirname + '/../frontend/static');

// Reading sql files, create a map of SQL filenames and their contents
const SQL_DIR = './sql/';
const SQL_FILES =
  fs.readdirSync(SQL_DIR)
    .map(file => [file, fs.readFileSync(path.join(SQL_DIR,file), 'utf8')])
    .reduce((map, [key, value]) => map.set(key, value), new Map())

console.log(`Launching application on port ${PORT}...`);
sqlite.open(__dirname + DB_FILE)
      .then(() => app.listen(PORT))
      .catch((e) => console.error(e));

// Serve our Elm application on /
app.get('/', (req, res) => res.sendFile(STATIC_DIR + '/index.html'));
app.use('/static', express.static(STATIC_DIR));

// Serve our api on /api
const data = express().get('/data/:column', function(req, res){
  const column = req.params.column;
  Promise.all(
    [
      sqlite.all(SQL_FILES.get('average_age_by_variable.sql'), [column]),
      sqlite.get(SQL_FILES.get('column_name.sql'), [column]),
    ]
  ).then(([data, {column}]) =>
    res.json({data, column})
  ).catch((err) => res.status(500).json({'error': err}));
});
const columns = express().get('/columns', function(req, res){
  sqlite.all(SQL_FILES.get('all_columns.sql')).then((data) =>
    res.json({data})
  ).catch((err) => res.status(500).json({error: err}));
});
app.use('/api', data);
app.use('/api', columns);

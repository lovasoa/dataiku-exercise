'use strict';
const express = require('express');
const sqlite = require('sqlite');
const path = require('path');
const fs = require('fs');

const app = express();
const DB_FILE = '/census.db';

// Read sql files, create a map of SQL filenames and their contents
const SQL_DIR = './sql/';
const SQL_FILES =
  fs.readdirSync(SQL_DIR)
    .map(file => [file, fs.readFileSync(path.join(SQL_DIR,file), 'utf8')])
    .reduce((map, [key, value]) => map.set(key, value), new Map());

// Get the list of available variables
app.get('/columns', function(req, res) {
  sqlite.all(SQL_FILES.get('all_columns.sql')).then((data) =>
    res.json({data})
  ).catch((err) => res.status(500).json({error: err}));
});

// Get the statistics for a variable
app.get('/data/:column', function(req, res){
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

const promise = sqlite.open(__dirname + DB_FILE);

module.exports = {app, promise};

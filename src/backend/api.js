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

/**
 * @api {get} /columns Get the list of available variables.
 * @apiVersion 1.0.0
 * @apiGroup Variables
 * @apiName GetColumns
 *
 * @apiSuccess {Object[]} data       List of columns.
 * @apiSuccess {Number}   data.id    Column id.
 * @apiSuccess {String}   data.name  Column name.
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "data": [
 *           {"id": 1, "name": "First column"}
 *        ]
 *     }
 *
 * @apiError ApiError An error occured while querying the database.
 *
 * @apiErrorExample Error-Response:
 *     HTTP/1.1 500 Internal Error
 *     {
 *       "error": "error description"
 *     }
 */
app.get('/columns', function(req, res) {
  sqlite.all(SQL_FILES.get('all_columns.sql')).then((data) =>
    res.json({data})
  ).catch((err) => res.status(500).json({error: err.code}));
});

/**
 * @api {get} /data/:column Get informations about the different values of a variable.
 * @apiVersion 1.0.0
 * @apiGroup Variables
 * @apiName GetColumn
 *
 * @apiParam {Number} id Column's unique ID.
 *
 * @apiSuccess {String}   column       Column name.
 * @apiSuccess {Object[]} data         List of columns.
 * @apiSuccess {String}   data.value   Value of the variable.
 * @apiSuccess {Number}   data.samples Number of people having this value of the variable.
 * @apiSuccess {Number}   data.age     Average age of the people having this value of the variable.
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "column" : "sex",
 *       "data": [
 *           {"age": 25.55126, "value": "male",   "samples": 31},
 *           {"age": 29.93206, "value": "female", "samples": 35}
 *        ]
 *     }
 *
 * @apiError ApiError An error occured while querying the database.
 *
 * @apiErrorExample Error-Response:
 *     HTTP/1.1 500 Internal Error
 *     {
 *       "error": "error description"
 *     }
 */
app.get('/data/:column', function(req, res){
  const column = req.params.column;
  Promise.all(
    [
      sqlite.all(SQL_FILES.get('average_age_by_variable.sql'), [column]),
      sqlite.get(SQL_FILES.get('column_name.sql'), [column]),
    ]
  ).then(([data, {column}]) =>
    res.json({data, column})
  ).catch((err) => res.status(500).json({'error': err.code}));
});

const promise = sqlite.open(__dirname + DB_FILE);

module.exports = {app, promise};

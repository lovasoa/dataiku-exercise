'use strict';
/**
Main server
Uses express to serve the API and the static files
**/
const express = require('express');
const path = require('path');
const fs = require('fs');
const api = require('./api.js');

const app = express();
const PORT = process.env.PORT || 3000;
const STATIC_DIR = path.resolve(__dirname + '/../frontend/static');

// Serve our Elm application on /
app.get('/', (req, res) => res.sendFile(STATIC_DIR + '/index.html'));
// Serve static content under /static
app.use('/static', express.static(STATIC_DIR));
// Serve our api on /api
app.use('/api', api.app);

// Run the server only when the API is ready
api.promise.then(() => {
  console.log(`Launching application on port ${PORT}...`);
  app.listen(PORT)
}).catch((err) => console.error(err));

#!/usr/bin/env bash

npm install

# Create the database file
rm -f ./src/backend/census.db # Remove the old optimized db if it exists
gunzip -k ./exercise/us-census.db.gz
./src/backend/import-db.py ./exercise/us-census.db

# Compile Elm files
cd ./src/frontend/
elm-make --yes Main.elm --output static/compiled.js

# Run the server
cd ../backend/
npm install
npm start

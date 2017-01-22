# Backend

A very simple node server (in `server.js`) serves the static files.
On load it requires the api file (`api.js`), that serves the api, under `/api`.
All SQL queries used in `api.js` are stored in the `sql/` folder, and are loaded
dynamically when the server starts.

## API documentation

The api is fully documented.
You can generate the decumentation automatically by running:

```
npm install
npm run apidoc
```

You will then find all the api documentation in HTML in the `doc/` folder.

#!/usr/bin/env python3

import sqlite3, sys
from os import path


if len(sys.argv) < 2:
    print("Usage: %s DB_FILE"  % (sys.argv[0]), file=sys.stderr)
    sys.exit(1)

# Takes the path of the database from the exercise
OLD_DB_FILE = sys.argv[1]

# Import data into the new database
NEW_DB_FILE = path.join(path.dirname(__file__), 'census.db')
old_db = sqlite3.connect(OLD_DB_FILE).cursor()
new_db = sqlite3.connect(NEW_DB_FILE).cursor()

# Create our data table
print("Creating new database schema...", file=sys.stderr)
new_db.executescript("""
    DROP TABLE IF EXISTS census;
    CREATE TABLE
      census (column TEXT, value TEXT NOT NULL, id INTEGER, age FLOAT NOT NULL,
            PRIMARY KEY (column, id));
""")

def fetch_data():
    """Returns an iterator over the data in the old db"""
    print("Starting row import. Go grab a coffee, it can take a few minutes.", file=sys.stderr)
    old_db.connection.row_factory = sqlite3.Row
    SQL_IMPORT = """
        SELECT rowid, *
        FROM census_learn_sql
        WHERE age IS NOT NULL
    """
    i = 0
    for row in old_db.connection.execute(SQL_IMPORT):
        for (column, value) in zip(row.keys(), row):
            if column not in ("rowid", "age") and value != None:
                yield (column, value, row["rowid"], row["age"])

        print("Imported %6d rows...\r" % (i,), end='', file=sys.stderr)
        i = i+1
    print("\nImported all rows.", file=sys.stderr)

SQL_INSERT = """
    INSERT INTO
        census (column,value,id,age)
    VALUES
             (?,?,?,?)
"""
# Inport the data in the new DB
new_db.executemany(SQL_INSERT, fetch_data())
new_db.connection.commit()
# Create our index and clean the db
print("Creating an index...", file=sys.stderr)
new_db.executescript("""
    DROP INDEX IF EXISTS census_idx;
    CREATE INDEX census_idx ON census (column, value, age);
""")
print("Cleaning the DB file...", file=sys.stderr)
new_db.execute("VACUUM")
new_db.connection.commit()

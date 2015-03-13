# 0.0.2

- renamed gem from g5-dbupdate to g5_dbupdate
- Added `gemfury_helpers` gem to `rake release` into Gemfury
- Added `.ruby-version` (2.2.1)
- Now dropdb and createdb properly before restoring the db
  - pg_restore breaks in some apps that uses hstore feature of postresql
  - see http://stackoverflow.com/questions/16225174/trouble-importing-heroku-postgresql-dump-to-local-database

# 0.0.1

- Initial working version

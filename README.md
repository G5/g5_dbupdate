# G5::DbUpdate

Replaces local postgresql db from heroku postresql db.
* Takes credentials from your rails app's `config/database.yml`.

# TODO

* Does not support database w/ passwords as of the moment.
  You still have to manually put the password when prompted.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g5_dbupdate'
```

And then execute:

    $ bundle

## Requirements

  * psql (PostgreSQL) 9.3.5
  * heroku toolbelt (https://toolbelt.heroku.com/)

## Usage

While in the root of your rails app:

```ruby
# Create a binstub for this gem.
# Otherwise, you'll always have to add `bundle exec`
bundle binstubs g5_dbupdate

# Default usage
g5_dbupdate

# Options
g5_dbupdate --clean # remove fetched latest.dump after restoring local db
g5_dbupdate --local # restore local db using previously fetched latest.dump
g5_dbupdate --verbose # verbose mode
```

## Testing

Run tests via `rspec spec`

```sh
$rspec spec
.

Finished in 0.05227 seconds (files took 0.36588 seconds to load)
1 example, 0 failures
```

## Contributing

1. Fork it ( https://github.com/g5/g5-db-update/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# G5::DbUpdate

Update local postgresql db from heroku postresql db

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g5-dbupdate'
```

And then execute:

    $ bundle

## Usage

While in the root of your rails app:

```ruby
# Create a binstub for this gem.
# Otherwise, you'll always have to add `bundle exec`
bundle binstubs g5-dbupdate

# Default usage
g5-dbupdate

# Options
g5-dbupdate --clean # remove fetched latest.dump after restoring local db
g5-dbupdate --local # restore local db using previously fetched latest.dump
g5-dbupdate --verbose # verbose mode
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/g5-db-update/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

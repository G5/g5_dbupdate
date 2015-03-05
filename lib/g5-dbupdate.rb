require "g5-dbupdate/version"
require 'rubygems'
require 'commander'
require 'yaml'

module G5
  module DbUpdate

    class Runner
      include Commander::Methods

      def run
        program :version, '0.0.1'
        program :description, 'Update local postgresql db from heroku postresql db'

        command :default do |c|
          c.syntax = 'g5-dbupdate [options]'
          c.summary = 'Update local postgresql db from heroku postresql db'
          c.description = 'Update local postgresql db from heroku postresql db'
          c.example 'description', 'g5-dbupdate --clean --verbose'
          c.option '--verbose', 'verbose mode'
          c.option '--local', 'do not fetch from heroku db and use local latest.dump fetched previously'
          c.option '--clean', 'force removal of latest.dump after '
          c.action do |args, options|
            unless options.local
              app_name = ask("Name of heroku app: ")
              puts "Fetching latest db dump from heroku app (#{app_name})..."
              system("curl -o latest.dump `heroku pgbackups:url --app #{app_name}`")
            end

            db_info = YAML.load_file('config/database.yml')
            destination_db = db_info["development"]["database"]
            username = db_info["development"]["username"]

            puts "Restoring into #{destination_db}..."
            verbosity="--verbose" if options.verbose
            system("pg_restore #{verbosity} --clean --no-acl --no-owner -U #{username} -d #{destination_db} latest.dump")

            if options.clean
              require 'fileutils'
              puts "Deleting latest.dump..."
              FileUtils.rm 'latest.dump'
            end
          end
        end
        default_command :default
        run!
      end
    end

  end
end


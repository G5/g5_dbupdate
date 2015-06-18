require "g5_dbupdate/version"
require 'rubygems'
require 'commander'
require 'yaml'
require 'fileutils'

module G5
  module DbUpdate

    class Runner
      include Commander::Methods

      def log_and_run_shell(shell_cmd)
        puts "running shell command: #{shell_cmd}"
        system(shell_cmd)
      end

      def run
        program :version, '0.0.1'
        program :description, 'Update local postgresql db from heroku postresql db'

        command :default do |c|
          c.syntax = 'g5_dbupdate [options]'
          c.summary = 'Replaces local postgresql db from heroku postresql db'
          c.description = 'Update local postgresql db from heroku postresql db'
          c.example 'description', 'g5_dbupdate --clean --verbose'
          c.option '--verbose', 'verbose mode'
          c.option '--local', 'do not fetch from heroku db and use local latest.dump fetched previously'
          c.option '--clean', 'force removal of tmp/latest.dump after restoring local db'
          c.action do |args, options|
            unless options.local
              app_name = ask("Name of heroku app: ")
              puts "Fetching latest db dump from heroku app (#{app_name})..."
              url = `heroku pg:backups public-url --app #{app_name} | cat`.chomp
              FileUtils.mkdir_p 'tmp'
              log_and_run_shell("curl -o tmp/latest.dump '#{url}'")
            end

            db_info = YAML.load_file('config/database.yml')
            destination_db = db_info["development"]["database"]
            username = db_info["development"]["username"] || db_info["development"]["user"]
            password = db_info["development"]["password"]
            host = db_info["development"]["host"]
            port = db_info["development"]["port"]

            puts "Restoring into #{destination_db}..."

            verbosity="--verbose" if options.verbose

            log_and_run_shell "dropdb #{destination_db}"
            log_and_run_shell "createdb -T template0 #{destination_db}"
            log_and_run_shell "pg_restore #{verbosity} --no-owner --username=#{username} --dbname=#{destination_db} tmp/latest.dump"

            if options.clean
              puts "Deleting tmp/latest.dump..."
              FileUtils.rm 'tmp/latest.dump'
            end
          end
        end
        default_command :default
        run!
      end
    end

  end
end


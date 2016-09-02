require "g5_dbupdate/version"
require 'rubygems'
require 'commander'
require 'yaml'
require 'fileutils'
require "open3"

module G5
  module DbUpdate

    class Runner
      include Commander::Methods

      def log_and_run_shell(shell_cmd)
        puts "running shell command: #{shell_cmd}"
        stdout_str, stderr_str, status = Open3.capture3(shell_cmd)
        unless status.success?
          fail(ArgumentError, "Error executing command: #{stderr_str}")
        end
        stdout_str.chomp
      end

      def load_db_info
        require 'erb'
        require 'dotenv'

        yaml = File.open('config/database.yml')
        erb_template = ERB.new(yaml.read)
        yaml.close

        # load environment first, if any
        Dotenv.load
        Dotenv.load('.env.development')

        YAML.load(erb_template.result)
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
            # moving to another method so this can be tested apart from commander gem
            default_action options
          end
        end
        default_command :default
        run!
      end

      def default_action(options)
        unless options.local
          app_name = ask("Name of heroku app: ")
          puts "Fetching latest db dump from heroku app (#{app_name})..."
          url = `heroku pg:backups public-url --app #{app_name} | cat`.chomp
          FileUtils.mkdir_p 'tmp'
          log_and_run_shell("curl -o tmp/latest.dump '#{url}'")
        end

        db_info = load_db_info
        destination_db = db_info["development"]["database"]
        username = db_info["development"]["username"] || db_info["development"]["user"]
        password = db_info["development"]["password"]
        host = db_info["development"]["host"] || "localhost"
        port = db_info["development"]["port"] || "5432"

        puts "Restoring into #{destination_db}..."

        verbosity="--verbose" if options.verbose

        connection_opts = [
          "--username=#{username}",
          "--host=#{host}",
          "--port=#{port}",
        ]
        connection_opts << "--password=#{password}" if !password.nil?

        dropdb_command = ["dropdb"]
        dropdb_command += connection_opts
        dropdb_command << destination_db
        log_and_run_shell dropdb_command.join(" ")

        createdb_command = ["createdb"]
        createdb_command += connection_opts
        createdb_command << "--template=template0"
        createdb_command << destination_db
        log_and_run_shell createdb_command.join(" ")

        pg_restore_command = [
          "pg_restore",
          verbosity,
          "--no-owner",
          "--dbname=#{destination_db}",
        ]
        pg_restore_command += connection_opts
        pg_restore_command << "tmp/latest.dump"
        log_and_run_shell(pg_restore_command.join(" "))

        if options.clean
          puts "Deleting tmp/latest.dump..."
          FileUtils.rm 'tmp/latest.dump'
        end
      end

    end

  end
end


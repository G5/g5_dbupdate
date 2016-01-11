require "spec_helper"

module G5
  module DbUpdate
    describe Runner do
      describe "#run", ":default" do
        let(:dbupdate_instance) { described_class.new }
        let(:command_options) do
          double(:command_options, {
            local: true,
            verbose: true,
            clean: false,
          })
        end

        it "replaces current db from a newly downloaded db dump from heroku" do
          expect(dbupdate_instance).to receive(:log_and_run_shell).
            with("dropdb g5_destination_db")
          expect(dbupdate_instance).to receive(:log_and_run_shell).
            with("createdb -T template0 g5_destination_db")
          expect(dbupdate_instance).to receive(:log_and_run_shell).
            with("pg_restore --verbose --no-owner --username=g5_username --dbname=g5_destination_db tmp/latest.dump")
          dbupdate_instance.default_action command_options
        end
      end
    end
  end
end

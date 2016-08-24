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
            with("dropdb --username=g5_username --host=myhost --port=2222 g5_destination_db")
          expect(dbupdate_instance).to receive(:log_and_run_shell).
            with("createdb --username=g5_username --host=myhost --port=2222 --template=template0 g5_destination_db")
          expect(dbupdate_instance).to receive(:log_and_run_shell).
            with("pg_restore --verbose --no-owner --dbname=g5_destination_db --username=g5_username --host=myhost --port=2222 tmp/latest.dump")
          dbupdate_instance.default_action command_options
        end
      end
    end
  end
end

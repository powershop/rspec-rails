module RSpec
  module Rails
    # @private
    module FixtureSupport
      if defined?(ActiveRecord::TestFixtures)
        extend ActiveSupport::Concern
        include RSpec::Rails::SetupAndTeardownAdapter
        include RSpec::Rails::MinitestLifecycleAdapter if ::ActiveRecord::VERSION::STRING > '4'
        include RSpec::Rails::MinitestAssertionAdapter
        include ActiveRecord::TestFixtures

        included do
          # TODO: (DC 2011-06-25) this is necessary because fixture_file_upload
          # accesses fixture_path directly on ActiveSupport::TestCase. This is
          # fixed in rails by https://github.com/rails/rails/pull/1861, which
          # should be part of the 3.1 release, at which point we can include
          # these lines for rails < 3.1.
          ActiveSupport::TestCase.class_exec do
            include ActiveRecord::TestFixtures
            self.fixture_path = RSpec.configuration.fixture_path
          end
          # /TODO

          self.fixture_path = RSpec.configuration.fixture_path
          self.use_transactional_fixtures = RSpec.configuration.use_transactional_fixtures
          self.use_instantiated_fixtures  = RSpec.configuration.use_instantiated_fixtures
          self.pre_loaded_fixtures        = RSpec.configuration.pre_loaded_fixtures
          fixtures RSpec.configuration.global_fixtures if RSpec.configuration.global_fixtures
        end
      end
    end
  end
end

ENV['RAILS_ENV'] = 'test'

if ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start 'rails'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require 'minitest/rails/capybara'

require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

# Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

module ActiveSupport
  # Test settings
  class TestCase
    ActiveRecord::Migration.check_pending!

    fixtures :all

    # include helper modules here
    # include MyCustomHelper

    def teardown
      ActionMailer::Base.deliveries.clear
    end
  end
end

Capybara.javascript_driver = :webkit

# Make all database transactions use the same thread
# needed for feature / integration tests with headless browser
# js tests use different threads
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end
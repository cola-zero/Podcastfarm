# -*- coding: utf-8 -*-
if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails' do
    use_merging(['test:units', 'test:functionals', 'test:integration'])
  end
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'capybara/rails'
require 'mocha'

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActiveRecord::TestFixtures

  alias :method_name :__name__ if defined? :__name__

  class << self
    alias :context :describe
  end
end

class ControllerSpec < MiniTest::Spec
  # include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior

  class << self
    alias :context :describe
  end

  before do
    @routes = Rails.application.routes
  end

  def build_message(*args)
    args[1].gsub(/\?/, '%s') % args[2..-1]
  end
end

# Functional tests = describe ***Controller
# MiniTest::Spec.register_spec_type( /Controller$/, ControllerSpec )
MiniTest::Spec.register_spec_type(ControllerSpec) do |desc|
  if desc.respond_to?(:superclass)
    desc.superclass == ApplicationController
  end
end

class HelperSpec < MiniTest::Spec
  include ActionView::TestCase::Behavior

  class DummyClass < ActionView::Base
    include ApplicationHelper
  end

  def helper
    @helper ||= DummyClass.new
  end

  before(:each) do
    helper.assign_controller(@controller)
  end
end

MiniTest::Spec.register_spec_type( /Helpers$/, HelperSpec)

# Functional tests = describe ***Controller
MiniTest::Spec.register_spec_type( /Controller$/, ControllerSpec )


class AcceptanceSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include Delorean

  self.use_transactional_fixtures = true

  before do
    @routes = Rails.application.routes
  end

  after do
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end

# Integration/Acceptance tests = describe '*** Integration'
MiniTest::Spec.register_spec_type( /Integration$/, AcceptanceSpec )

# Capybara.app_host = 'http://localhost:3000'
Capybara.default_driver = :webkit
Capybara.default_selector = :css
# Capybara.javascript_driver = :webkit

def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
ensure
  page.evaluate_script "window.confirm = window.original_confirm_function"
end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module TransactionalTests
  # See minitest doco - use_transactional_fixtures_but_in_ruby
  # to use include this into your test case
  def run(runner)
    test_result = nil
    ActiveRecord::Base.transaction { test_result = super; raise ActiveRecord::Rollback }
    test_result
  end
end

def set_omniauth_mock( options = nil)
  OmniAuth.config.test_mode = true
  if options == nil
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => { 'nickname' => 'cola_zero',
        'name' => 'こーら'}
    }
  elsif options[:invalid] == true
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection


GirlFriday::Queue.immediate!

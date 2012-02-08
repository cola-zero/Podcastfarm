# -*- coding: utf-8 -*-
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
  desc.superclass == ApplicationController
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

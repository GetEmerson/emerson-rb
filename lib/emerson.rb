require "emerson/version"
require "emerson/engine"

module Emerson
  autoload :Responder, 'emerson/responder'
  autoload :Response,  'emerson/response'
  autoload :Scope,     'emerson/scope'

  # Custom path for fixture files.
  #
  # @note  This attribute **must** be set in order to use the included response
  #   matchers. If RSpec fixtures are disabled, be sure to enable specifically
  #   for Emerson.
  #
  # @param value [String] the path. Defaults to RSpec's `fixture_path`.
  mattr_accessor :fixture_path
  @@fixture_path = nil

  # Default way to setup Emerson. For Rails, call from an initializer.
  #
  # @example in 'config/initializers/emerson.rb'
  #   Emerson.setup do |config|
  #     config.fixture_path = Rails.root.join('custom/path')
  #   end
  def self.setup
    # some defaults:
    if defined?(RSpec)
      self.fixture_path ||= RSpec.configuration.fixture_path
    end

    yield self
  end
end

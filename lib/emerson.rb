require "emerson/version"
require "emerson/engine"

module Emerson
  autoload :Responder, 'emerson/responder'
  autoload :Response,  'emerson/response'
  autoload :Scope,     'emerson/scope'

  mattr_accessor :fixture_path
  @@fixture_path = nil

  def self.setup
    # some defaults:
    if defined?(RSpec)
      self.fixture_path ||= RSpec.configuration.fixture_path
    end

    yield self
  end
end

require "emerson/version"
require "emerson/engine"

module Emerson
  autoload :Responder, 'emerson/responder'
  autoload :Response,  'emerson/response'
  autoload :Scope,     'emerson/scope'

  # Hook for enabling a specific set of Emerson "features".
  #
  # @note The disabling arguments (`nil`, `false`) are included for
  #   completeness. A better way to disable Emerson features would be to
  #   **not** include `Emerson::Response` in your controller(s).
  #
  # @param value [Array, Symbol, false, nil] The list of features,
  #   `:all` (default), `nil` or `false` (to disable completely).
  mattr_accessor :features
  @@features = :all

  # Custom path for fixture files.
  #
  # @note This attribute **must** be set in order to use the included response
  #   matchers. If RSpec fixtures are disabled, be sure to enable specifically
  #   for Emerson.
  #
  # @param value [String] The path. Defaults to RSpec's `fixture_path`.
  mattr_accessor :fixture_path
  @@fixture_path = nil

  mattr_accessor :response_config
  @@response_config = {
    :json_default => 'full'
  }

  # Default way to setup Emerson. For Rails, call from an initializer.
  #
  # @example in 'config/initializers/emerson.rb'
  #   Emerson.setup do |config|
  #     config.fixture_path = Rails.root.join('custom/path')
  #   end
  def self.setup
    # # environmental defaults:
    # # TODO: rethink this to remove implicit ActiveRecord dependency.
    # if defined?(RSpec)
    #   self.fixture_path ||= RSpec.configuration.fixture_path
    # end

    yield self
  end

  # Helper to determine whether `Emerson::Responder` is enabled.
  def self.responder_enabled?
    self.feature_enabled?(:responder)
  end

  # Helper to determine whether `Emerson::Scope` is enabled.
  def self.scope_enabled?
    self.feature_enabled?(:scope)
  end

  private

    def self.feature_enabled?(key)
      self.features.present? && (self.features == :all || self.features.include?(key))
    end
end

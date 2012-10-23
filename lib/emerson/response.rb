module Emerson
  # Adds Emerson response handling & rendering.
  #
  # @example
  #   class ApplicationController < ActionController::Base
  #     include Emerson::Response
  #   end
  module Response
    class << self
      # Configures `base` with the follow feature flag awareness:
      #
      #   * if `Emerson.scope_enabled?`, will include `Emerson::Scope`
      #   * if `Emerson.responder_enabled?`, will set up `base.responder` to
      #     use `Emerson::Responder` with `:html` and `:json` mime types.
      def included(base)
        base.send(:include, Emerson::Scope) if Emerson.scope_enabled?

        if Emerson.responder_enabled?
          base.responder = Emerson::Responder
          base.class_eval('respond_to(:html, :json)')
        end
      end
    end
  end
end

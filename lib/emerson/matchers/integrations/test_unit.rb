# :enddoc:

if defined?(ActionController)
  require 'emerson/matchers/action_controller'

  class ActionController::TestCase
    include Emerson::Matchers::ActionController
    extend Emerson::Matchers::ActionController

    def subject
      @controller
    end
  end
end

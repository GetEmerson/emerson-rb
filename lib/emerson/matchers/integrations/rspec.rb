if defined?(::ActionController)
  require 'emerson/matchers/action_controller'

  module RSpec
    module Rails
      module ControllerExampleGroup
        include Emerson::Matchers::ActionController
      end
    end
  end
end

module Emerson
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Emerson
    end
  end
end

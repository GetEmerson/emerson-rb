module Emerson
  module Response
    class << self
      def included(base)
        base.send(:include, Emerson::Scope)
        base.responder = Emerson::Responder
        base.class_eval('respond_to(:html, :json, :js)')
      end
    end
  end
end

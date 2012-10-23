require 'action_controller/base'

module Emerson
  module Scope
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        # TODO: consider...
        # helper_method :current_scope
        class_attribute :scope_configuration
      end
    end

    module ClassMethods
      def scope(*args)
        options   = args.extract_options!
        resources = args.shift

        unless options.key?(:by)
          raise ArgumentError.new(".scopes requires a :by option")
        end

        unless resources.present?
          raise ArgumentError.new(".scopes requires a (plural) resources type")
        end

        self.scope_configuration   ||= [resources, []]
        self.scope_configuration[1] += [options[:by]].flatten
        self.scope_configuration[1].uniq!
      end
    end

    def scoped(explicit = nil)
      @_scoped ||= begin
        if scope_configuration.present?
          target = scope_configuration.first

          if explicit.present?
            @scope = explicit
            @scope.send(target)
          elsif scope = scope_from_params
            @scope = scope
            @scope.send(target)
          else
            @scope = nil # be explicit
            class_for(singular(target)).scoped
          end
        else
          @scope = nil # be explicit
          default_scope
        end
      end
    end

    def current_scope
      @_current_scope ||= begin
        if @scope.present?
          @scope.class.model_name.plural.intern
        end
      end
    end

    protected

      def scope_from_params
        param = nil
        type  = self.scope_configuration.last.find { |scope| (param = params["#{scope}_id"]) && param }

        return nil unless type

        class_for(type).find(param)
      end

    private

      def class_for(type)
        type.to_s.classify.constantize
      end

      def default_scope
        klass = class_for(singular(self.class.name.sub(/Controller$/, '')))
        klass.scoped
      end

      def singular(plural)
        plural.to_s.singularize
      end
  end
end

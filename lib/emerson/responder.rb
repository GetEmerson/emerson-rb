require 'action_controller/base'

module Emerson
  class Responder < ActionController::Responder
    # class << self
    #   def base_decorator=(value)
    #     @@base_decorator = value
    #   end
    # 
    #   def base_decorator
    #     # NOTE: requires definition of BaseDecorator
    #     @@base_decorator ||= BaseDecorator
    #   end
    # end

    delegate :render_to_string, :to => :controller

    def initialize(*)
      super
      # NOTE: don't love the @resource ivar...
      # may be able to remove in favor of layouts
      controller.instance_variable_set(:"@resource", decorate(resource))
    end

    def to_html
      render(render_args)
    rescue ActionView::MissingTemplate
      debug(:missing_template)
      super
    end

    def to_json
      # JSON rendering:
      # 1. try xxx.json.erb
      # 2. fail over to xxx.html.erb
      controller.formats = [:json, :html]

      render({
        :json => {
          :data => locals,
          :view => render_to_string(render_args(:layout => false)).gsub(/\n/, '').presence,
        }
        # TODO: consider adding (with proper logic)...
        # :location => location,
        # :status   => status
      })
    rescue ActionView::MissingTemplate
      debug(:missing_template)
      to_format
    end

    private

      def action
        @_action ||= (@action || controller.action_name).intern
      end

      def decorated_resources
        # NOTE: would like to use controller.current_scope, but i claimed that for the symbol
        scope   = controller.instance_variable_get(:"@scope")
        results = ([scope] + resources).compact
        decorate(results)
      end

      def locals
        @_locals ||= begin
          base = (options[:locals] || {})
          base.each do |k, v|
            base[k] = decorate(v)
          end

          decorated_resources.inject(base) do |memo, object|
            memo[key_for(object)] = object
            memo
          end
        end
      end

      def render_args(overrides = {})
        # TODO: spec me!
        @_render_args ||= begin
          if options[:layout] == :scoped
            options.delete(:layout)
            options[:layout] = controller.current_scope.to_s if controller.current_scope.present?
          end

          options.merge({
            :template => template,
            :locals   => locals
          }).merge(overrides) # TODO: options first?
        end
      end

      def template
        @_template ||= begin
          if options[:location].present?
            nil
          elsif (path = options[:path])
            # TODO: spec me!
            if path == :scoped
              options[:path] = template_built(controller.current_scope)
            end

            options[:path]
          else
            template_built
          end
        end
      end

      def template_built(prefix = nil)
        @_template_default ||= [prefix, template_base, template_method].compact.join('/')
      end

      def template_base
        @_template_base ||= controller.controller_path
      end

      def template_method
        @_template_method ||= if get?
          action
        elsif delete?
          :index
        elsif has_errors?
          default_action
        else
          :show
        end
      end

      def decorate(object)
        # ActiveDecorator::Decorator.instance.decorate(object)
        object
      end

      def key_for(object)
        if object == resource
          key_for_primary
        else
          key_for_related(object)
        end
      end

      # The primary resource is keyed per the request.
      def key_for_primary
        @_key_for_primary ||= if options[:as]
          options[:as]
        else
          controller_name = controller.controller_name
          (resource.respond_to?(:each) ? controller_name : controller_name.singularize).intern
        end
      end

      def key_for_related(object)
        # for now, assume :model_name
        object.class.model_name.element.intern
      end

      def debug(type)
        # TODO: check Emerson.debug?
        case type
        when :missing_template
          controller.logger.warn("Emerson::Responder failed to locate template: #{render_args[:template].inspect}")
        end
      end
  end
end

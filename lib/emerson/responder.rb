require 'action_controller/base'

module Emerson
  # Add conventions for resourceful rendering and responses.
  class Responder < ActionController::Responder
    delegate :render_to_string, :to => :controller

    def initialize(*)
      super
      # NOTE: don't love the @resource ivar...
      controller.instance_variable_set(:"@resource", resource)
    end

    def to_html
      render(render_args)
    rescue ActionView::MissingTemplate
      debug(:missing_template)
      super
    end

    def to_json
      if (mode = vendor_mode)
        controller.formats = [:json, :html]

        json = {}.tap do |hash|
          unless_mode(:view) { hash[:data] = locals }
          unless_mode(:data) do
            hash[:view] = render_to_string(render_args(:layout => false)).gsub(/\n/, '').presence
          end
        end

        render(:json => json)
      else
        to_format
      end
    rescue ActionView::MissingTemplate
      debug(:missing_template)

      controller.formats = [:json]
      to_format
    end

    private

      def unless_mode(mode)
        (vendor_mode == mode) ? nil : yield
      end

      # TODO: Emerson.vendor_pattern =
      #       "application/vnd.emerson[.{version}][.(full|data|view)]+json"
      def vendor_pattern
        /application\/vnd\.emerson(\.([a-z]+))?\+json/
      end

      def vendor_mode
        @_vendor_mode ||= begin
          result = false

          if (header = request.env['HTTP_ACCEPT'])
            if (match = header.match(vendor_pattern))
              result = (match[2] || 'full').intern
            end
          end

          result
        end
      end

      def action
        @_action ||= (@action || controller.action_name).intern
      end

      # TODO: rename for accuracy
      def locals
        @_locals ||= begin
          scope   = controller.instance_variable_get(:"@scope")
          results = ([scope] + resources).compact

          (options[:locals] || {}).tap do |hash|
            results.each do |object|
              hash[key_for(object)] = object
            end
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

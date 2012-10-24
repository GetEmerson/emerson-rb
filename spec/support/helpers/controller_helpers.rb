module Support
  module ControllerHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      # Override `ControllerExampleGroup.controller` for some nice sugar.
      # See instance method below.
      def controller(key, base = nil)
        klass = Class.new(base || ApplicationController) do
          include Emerson::Response
        end

        klass.class_eval <<-CODE
          def self.name
            @_name ||= [key, 'controller'].join('_').camelcase
          end

          def self.key
            @_key ||= '#{key}'.intern
          end

          def #{key}
            resources
          end

          def resources=(value)
            @resources = value
          end

          def resources
            @resources
          end

          # Scope helper
          def class_for(type)
            "Support::ResourceHelpers::\#{type.to_s.classify}".constantize
          end
        CODE

        metadata[:example_group][:described_class] = klass

        before do
          @_resource_type = key
        end
      end
    end

    # Add `#controller` ExampleGroup instance method which, combined with the
    # overriden class method above, provides the ability to:
    #
    # @example
    #   describe "GET #index" do
    #     controller(:products)
    #
    #     before do
    #       controller do
    #         def index
    #           respond_with(products)
    #         end
    #       end
    #     end
    #
    #     it "is successful" do
    #       get(:index)
    #       expect(response).to be_success
    #     end
    #   end
    def controller(*args, &body)
      if block_given?
        controller_class.class_eval(&body)

        resource_set = self.instance_variable_get('@_resources')
        resource_set = self.instance_variable_get('@__memoized') unless resource_set.present?
        resource_key = "#{controller_class.key}".singularize.intern

        @controller.resources = (resource_set[resource_key] || resource_set[controller_class.key])
      end

      super()
    end

    def controller_class
      described_class
    end

    # Wrap `ActionController::TestCase::Behavior` actions in
    # a warm routing embrace.
    def process(*)
      with_routing do |routes|
        routes.instance_eval "
          draw { resources #{@_resource_type.inspect} }
        "

        super
      end
    end
  end
end

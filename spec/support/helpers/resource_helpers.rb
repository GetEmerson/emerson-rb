require 'virtus'

module Support
  module ResourceHelpers
    def reset_resources
      Example.records = []
      User.records    = []
    end

    def resource(type)
      resources(type)[0]
    end

    def resources(type, count = nil)
      @_resources ||= {}

      if count.present? || @_resources[type].blank?
        model   = resource_class(type)
        count ||= 1
        count.times { model.create }

        @_resources[type] = model.records
      end

      @_resources[type]
    end

    def resource_class(type)
      case type
      when :example
        Example
      when :user
        User
      end
    end

    class Example
      include Virtus
      extend  ActiveModel::Naming
      include ActiveModel::Conversion
      include ActiveModel::Validations

      attribute :id,
        Fixnum, :default => lambda { |inst, attr| inst.class.records.length + 1 }
      attribute :name,
        String, :default => lambda { |inst, attr| Faker::Name.name }

      class_attribute :records
      self.records = []

      # Emulating ActiveRecord class methods
      class << self
        def create
          record = self.new

          self.records << record
          record
        end

        def find(id)
          self.records.first { |r| r.id == id.to_i }
        end

        def scoped
          self.records
        end
      end
    end

    class User < Example
      attribute :examples,
        Array, :default => lambda { |inst, attr| [Example.new, Example.new] }

      self.records = []
    end
  end
end

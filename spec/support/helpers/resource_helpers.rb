require 'virtus'

module Support
  module ResourceHelpers
    def reset_resources
      Product.records = []
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
      when :product
        Product
      when :user
        User
      end
    end

    class Base
      include Virtus
      extend  ActiveModel::Naming
      include ActiveModel::Conversion
      include ActiveModel::Validations

      attribute :id,   Fixnum, :default => :default_id
      attribute :name, String, :default => :default_name

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

      def default_id
        Faker::Lorem.word
      end

      def default_name
        Faker::Lorem.word
      end
    end

    class Product < Base
      def default_name
        Faker::Product.product_name
      end
    end

    class User < Base
      attribute :products, Array, :default => :default_products

      # self.records = []
      def default_name
        Faker::Name.name.gsub(/[']/, '')
      end

      def default_products
        [Product.new, Product.new]
      end
    end
  end
end

require "spec_helper"

describe Emerson::Scope, :type => :controller do
  render_views
  let!(:products) { resources(:product, 2) }

  controller(:products)

  before do
    templates do
      def index
        <<-ERB
        <ul>
          <% products.each do |product| %>
          <li><%= product.name %></li>
          <% end %>
        </ul>
        ERB
      end
    end
  end

  describe ".scope" do
    context "called without a 'resources' argument" do
      it "raises an exception" do
        expect {
          controller_class.class_eval do
            scope :by => :user
          end
        }.to raise_error(ArgumentError)
      end
    end

    context "called without the :by requirement" do
      it "raises an exception" do
        expect {
          controller_class.class_eval do
            scope :products
          end
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#current_scope" do
    let(:user) { resource(:user) }

    before do
      user.products = [products.first]

      controller do
        scope :products, :by => :user

        def index
          render(:json => { :user => current_scope.id })
        end
      end
    end

    it "returns the record representing the current scope" do
      get(:index, :user_id => user.id)
      expect(response).to send_json({
        :user => user.id
      })
    end

    context "detailed scope configurations and environments" do
      it "is pending" do
        pending "TODO"
      end
    end
  end

  describe "#scoped" do
    context "without a scope configuration" do
      before do
        controller do
          def index
            respond_with(scoped)
          end
        end
      end
  
      it "selects the resource using the default scope, from the controller name" do
        get(:index)
        expect(response.body).to have_css('ul > li', :text => products[0].name)
        expect(response.body).to have_css('ul > li', :text => products[1].name)
      end
    end
  
    context "with a scope configuration" do
      let(:user) { resource(:user) }

      before do
        user.products = [products.first]

        controller do
          scope :products, :by => :user

          def index
            respond_with(scoped)
          end
        end
      end

      context "given no scoping environment" do
        it "selects the resource using the default scope, from configuration" do
          get(:index)
          expect(response.body).to have_css('ul > li', :text => products[0].name)
          expect(response.body).to have_css('ul > li', :text => products[1].name)
        end
      end

      context "given a scoping environment based on request params" do
        it "selects the resource using the provided scope" do
          get(:index, :user_id => user.id)
          expect(response.body).to     have_css('ul > li', :text => products[0].name)
          expect(response.body).to_not have_css('ul > li', :text => products[1].name)
        end
      end
    end

    context "with a scope configuration and a scoping environment as a specific object" do
      let(:user) { resource(:user) }

      before do
        user.products = [products.first]

        controller.stub(:user) { user }
        controller do
          scope :products, :by => :user

          def index
            respond_with(scoped(user))
          end
        end
      end

      it "selects the resource using the provided scope" do
        get(:index)
        expect(response.body).to     have_css('ul > li', :text => products[0].name)
        expect(response.body).to_not have_css('ul > li', :text => products[1].name)
      end
    end
  end
end

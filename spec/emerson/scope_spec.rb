require "spec_helper"

describe Emerson::Scope, :type => :controller do
  render_views

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
            scope :examples
          end
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#scoped" do
    let!(:examples) { resources(:example, 2) }

    before do
      controller.stub(:resource) { examples }
      stub_template('examples/index.html.erb' => "<ul><% examples.each do |ex| %><li><%= ex.name %></li><% end %></ul>")
    end
  
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
        expect(response.body).to have_css('ul > li', :text => examples[0].name)
        expect(response.body).to have_css('ul > li', :text => examples[1].name)
      end
    end
  
    context "with a scope configuration" do
      let(:user) { resource(:user) }

      before do
        user.examples = [examples.first]

        controller do
          scope :examples, :by => :user

          def index
            respond_with(scoped)
          end
        end
      end

      context "given no scoping environment" do
        it "selects the resource using the default scope, from configuration" do
          get(:index)
          expect(response.body).to have_css('ul > li', :text => examples[0].name)
          expect(response.body).to have_css('ul > li', :text => examples[1].name)
        end
      end

      context "given a scoping environment based on request params" do
        it "selects the resource using the provided scope" do
          get(:index, :user_id => user.id)
          expect(response.body).to     have_css('ul > li', :text => examples[0].name)
          expect(response.body).to_not have_css('ul > li', :text => examples[1].name)
        end
      end
    end

    context "with a scope configuration and a scoping environment as a specific object" do
      let(:user) { resource(:user) }

      before do
        user.examples = [examples.first]

        controller.stub(:user) { user }
        controller do
          scope :examples, :by => :user

          def index
            respond_with(scoped(user))
          end
        end
      end

      it "selects the resource using the provided scope" do
        get(:index)
        expect(response.body).to     have_css('ul > li', :text => examples[0].name)
        expect(response.body).to_not have_css('ul > li', :text => examples[1].name)
      end
    end
  end

  private

    controller(ApplicationController) do
      include Emerson::Response

      def self.name
        'ExamplesController'
      end

      private

        # Would typically be derived from the controller name. However,
        # we do not have and `Example` class.
        def class_for(type)
          "Support::ResourceHelpers::#{type.to_s.camelcase}".constantize
        end
    end

    # Helper for augmenting the controller class for a given example.
    def controller(&body)
      if block_given?
        controller_class.class_eval(&body)
      end

      super
    end

    def controller_class
      described_class
    end

    def get(action, params = {})
      with_routing do |map|
        map.draw do
          match 'examples'     => 'examples#index'
          match 'examples/:id' => 'examples#show'
        end

        super(action, params)
      end
    end
end

require "spec_helper"

describe Emerson::Responder, :type => :controller do
  # We fake render, but don't want to blow up when RSpec tries to sweep later.
  render_views

  describe "GET #index" do
    before do
      # controller.setup do |c|
      #   c.resources(:index => resources(5))
      #   c.templates(:index => "<ul><% examples.each do |ex| %><li><%= ex.name %></li><% end %></ul>")
      # end

      @controller.stub(:resource).and_return(records(2))
      stub_template('examples/index.html.erb' => "<ul><% examples.each do |ex| %><li><%= ex.name %></li><% end %></ul>")
    end

    context "as HTML" do
      it "is successful" do
        get(:index)
        expect(response).to be_success
      end

      it "responds with the expected template" do
        get(:index)
        expect(response).to render_template(:template => 'index')
      end

      it "responds with the expected locals" do
        get(:index)
        expect(response.body).to have_css('ul > li', :text => records[0].name)
        expect(response.body).to have_css('ul > li', :text => records[1].name)
      end
    end

    context "as JSON (application/json - default)" do
      it "is successful" do
        get(:index, :format => :json)
        expect(response).to be_success
      end

      it "responds with the expected JSON" do
        get(:index, :format => :json)
        expect(response).to send_json(records)
      end
    end

    context "as JSON (application/vnd.emerson+json)" do
      before do
        request.env['HTTP_ACCEPT'] = 'application/vnd.emerson+json'
      end

      it "is successful" do
        get(:index, :format => :json)
        expect(response).to be_success
      end

      it "responds with the expected JSON" do
        get(:index, :format => :json)

        expect(response).to send_json({
          :data => {
            :examples => records
          },
          :view => "<ul><li>#{records[0].name}</li><li>#{records[1].name}</li></ul>"
        })
      end

      context "when a custom `.json` template is found" do
        before do
          stub_template('examples/index.json.erb' => "<%= examples.map(&:name).to_json.html_safe %>")
        end

        it "responds using the template for the :view" do
          get(:index, :format => :json)

          expect(response).to send_json({
            :data => {
              :examples => records
            },
            :view => records.map(&:name).to_json
          })
        end
      end

      context "when the target template is missing" do
        it "fails over to the default behavior" do
          get(:index, :format => :json, :path => 'bogus')
          expect(response).to send_json(records)
        end
      end
    end

    context "as JSON (application/vnd.emerson.data+json)" do
      before do
        request.env['HTTP_ACCEPT'] = 'application/vnd.emerson.data+json'
      end

      it "is successful" do
        get(:index, :format => :json)
        expect(response).to be_success
      end

      it "responds with the expected JSON" do
        get(:index, :format => :json)

        expect(response).to send_json({
          :data => {
            :examples => records
          }
        })
      end
    end

    context "as JSON (application/vnd.emerson.view+json)" do
      before do
        request.env['HTTP_ACCEPT'] = 'application/vnd.emerson.view+json'
      end

      it "is successful" do
        get(:index, :format => :json)
        expect(response).to be_success
      end

      it "responds with the expected JSON" do
        get(:index, :format => :json)

        expect(response).to send_json({
          :view => "<ul><li>#{records[0].name}</li><li>#{records[1].name}</li></ul>"
        })
      end

      context "when a custom `.json` template is found" do
        before do
          stub_template('examples/index.json.erb' => "<%= examples.map(&:name).to_json.html_safe %>")
        end

        it "responds using the template for the :view" do
          get(:index, :format => :json)

          expect(response).to send_json({
            :view => records.map(&:name).to_json
          })
        end
      end
    end
  end

  private

    controller(ApplicationController) do
      include Emerson::Response

      def self.name
        'ExamplesController'
      end

      def index
        respond_with(resource, :path => params[:path])
      end
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

    def stub_template(hash)
      @controller.view_paths.unshift(ActionView::FixtureResolver.new(hash))
    end
end

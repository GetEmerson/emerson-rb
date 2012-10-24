require "spec_helper"

describe Emerson::Responder, :type => :controller do
  render_views
  let!(:products) { resources(:product, 2) }

  describe "GET #index" do
    controller(:products)

    before do
      controller do
        def index
          respond_with(products)
        end
      end

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
        expect(response.body).to have_css('ul > li', :text => products[0].name)
        expect(response.body).to have_css('ul > li', :text => products[1].name)
      end
    end

    context "as JSON (application/json - default)" do
      it "is successful" do
        get(:index, :format => :json)
        expect(response).to be_success
      end

      it "responds with the expected JSON" do
        get(:index, :format => :json)
        expect(response).to send_json(products)
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
            :products => products
          },
          :view => "<ul><li>#{products[0].name}</li><li>#{products[1].name}</li></ul>"
        })
      end

      context "when a custom `.json` template is found" do
        before do
          stub_template('products/index.json.erb' => "<%= products.map(&:name).to_json.html_safe %>")
        end

        it "responds using the template for the :view" do
          get(:index, :format => :json)

          expect(response).to send_json({
            :data => {
              :products => products
            },
            :view => products.map(&:name).to_json
          })
        end
      end

      context "when the target template is missing" do
        before do
          controller do
            def index
              respond_with(products, :path => 'bogus/path')
            end
          end
        end

        it "fails over to the default behavior" do
          get(:index, :format => :json)
          expect(response).to send_json(products)
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
            :products => products
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
          :view => "<ul><li>#{products[0].name}</li><li>#{products[1].name}</li></ul>"
        })
      end

      context "when a custom `.json` template is found" do
        before do
          stub_template('products/index.json.erb' => "<%= products.map(&:name).to_json.html_safe %>")
        end

        it "responds using the template for the :view" do
          get(:index, :format => :json)

          expect(response).to send_json({
            :view => products.map(&:name).to_json
          })
        end
      end
    end

    context "with Scope" do
      let(:user) { resource(:user) }

      before do
        user.products = [products.first]
      end

      context "when :path is customized as :scoped" do
        before do
          template('users/products/index.html.erb' => '<p>custom template</p>')

          controller do
            scope :products, :by => :user

            def index
              respond_with(scoped, :path => :scoped)
            end
          end
        end

        it "responds with the expected template" do
          get(:index, :user_id => user.id)
          expect(response.body).to have_css('p', :text => 'custom template')
        end
      end

      context "when :layout is customized as :scoped" do
        before do
          template({
            'users.html.erb' => '<p>custom layout</p>',
            :layout => true
          })

          controller do
            scope :products, :by => :user

            def index
              respond_with(scoped, :layout => :scoped)
            end
          end
        end

        it "responds with the expected layout" do
          get(:index, :user_id => user.id)
          expect(response.body).to have_css('p', :text => 'custom layout')
        end
      end
    end
  end
end

require "spec_helper"

describe Emerson::Response, :type => :controller do
  it "is not automatically included" do
    expect(ApplicationController.included_modules).to_not include(Emerson::Response)
  end

  context "when included" do
    before do
      expect(controller_class).to include(Emerson::Response)
    end

    it "includes Emerson::Scope" do
      expect(controller_class).to include(Emerson::Scope)
    end

    it "configures the responder" do
      expect(controller_class.responder).to eq(Emerson::Responder)
    end

    it "configures the :respond_to mimes" do
      expect(controller_class.mimes_for_respond_to).to eq({ :html => {}, :json => {} })
    end
  end

  context "when the :responder feature is disabled" do
    let(:inline_controller) do
      Class.new(ApplicationController) do
        include Emerson::Response
      end
    end

    around do |example|
      with_features(nil) { example.run }
    end

    it "does not configure the responder" do
      expect(inline_controller.responder).to eq(ActionController::Responder)
    end

    it "does not configure the :respond_to mimes" do
      expect(inline_controller.mimes_for_respond_to).to eq({})
    end
  end

  context "when the :scope feature is disabled" do
    let(:inline_controller) do
      Class.new(ApplicationController) do
        include Emerson::Response
      end
    end

    around do |example|
      with_features(nil) { example.run }
    end

    it "does not include Emerson::Scope" do
      expect(inline_controller).to_not include(Emerson::Scope)
    end
  end

  private

    controller(ApplicationController) do
      include Emerson::Response

      def self.name
        'ProductsController'
      end
    end

    def controller_class
      described_class
    end
end

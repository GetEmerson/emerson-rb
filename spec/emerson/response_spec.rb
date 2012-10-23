require "spec_helper"

describe Emerson::Response, :type => :controller do
  it "is not automatically included" do
    expect(ApplicationController.included_modules).to_not include(Emerson::Response)
  end

  context "when included" do
    before do
      expect(controller_class).to include(Emerson::Response)
    end

    it "configures the responder" do
      expect(controller_class.responder).to eq(Emerson::Responder)
    end

    it "includes Emerson::Scope" do
      expect(controller_class).to include(Emerson::Scope)
    end
  end

  private

    controller(ApplicationController) do
      include Emerson::Response

      def self.name
        'ExamplesController'
      end
    end

    def controller_class
      described_class
    end
end

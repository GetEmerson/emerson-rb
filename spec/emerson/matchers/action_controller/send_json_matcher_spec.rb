require "spec_helper"

describe Emerson::Matchers::ActionController::SendJsonMatcher, :type => :controller do
  let(:do_request) { get :index, :format => :json }
  let!(:products)  { { :one => 1, :two => 2 } }

  controller(:products)

  before do
    controller do
      respond_to :json

      def index
        respond_with(products)
      end
    end

    do_request
    expect(response.body).to eq(products.to_json)
  end

  context "provided a Hash representing the expected JSON" do
    it "provides a helpful description" do
      matcher = send_json({})
      expect(matcher.description).to eq('send JSON: (provided)')
    end

    it "accepts exact matches" do
      expect(response).to send_json(products)
    end

    it "accepts valid matches with re-ordered pairs" do
      expect(response).to send_json({ :two => 2, :one => 1})
    end

    it "rejects invalid matches" do
      expect(response).to_not send_json({})
      expect(response).to_not send_json({ :one => 2, :two => 1 })
      expect(response).to_not send_json(products.to_json)
    end
  end

  context "provided an Array representing the expected JSON" do
    let(:products) { [:one, :two] }

    it "provides a helpful description" do
      matcher = send_json([])
      expect(matcher.description).to eq('send JSON: (provided)')
    end

    it "accepts exact matches" do
      expect(response).to send_json(products)
    end

    it "rejects invalid matches" do
      expect(response).to_not send_json({})
      expect(response).to_not send_json([])
      expect(response).to_not send_json([:two, :one])
    end
  end

  context "provided a String representing a JSON fixture lookup" do
    let(:name) { 'products/simple' }

    it "provides a helpful description" do
      matcher = send_json(name)
      expect(matcher.description).to eq('send JSON: products/simple.json')
    end

    it "accepts valid matches" do
      expect(response).to send_json(name)
      expect(response).to send_json("#{name}.json")
    end

    it "rejects invalid matches" do
      expect(response).to_not send_json('products/bogus')
    end
  end

  context "provided something other than a Hash or String" do
    it "raises an exception" do
      expect { send_json(:symbol) }.to raise_error(ArgumentError)
    end
  end

  context "given JSON with the `$extends` keyword" do
    let(:products) { { :one => 1, :two => 2, :addition => 'more' } }

    it "accepts valid matches" do
      expect(response).to send_json('products/extend-success')
      expect(response).to send_json('products/extend-array')
    end

    it "rejects valid matches" do
      expect(response).to_not send_json('products/extend-failure')
    end
  end

  context "given a failed match" do
    it "provides a helpful failure message" do
      matcher = send_json({ :bogus => 'value' })
      expect(matcher.matches?(response)).to eq(false)

      message = matcher.failure_message
      expect(message).to match(failure_message)
    end
  end

  private

    def failure_message
      <<-EOMSG
Expected actual response:
------------------------------------------------------------
{
  "one": 1,
  "two": 2
}
to match:
------------------------------------------------------------
{
  "bogus": "value"
}
      EOMSG
    end
end

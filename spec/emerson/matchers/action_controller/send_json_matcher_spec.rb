require "spec_helper"

describe Emerson::Matchers::ActionController::SendJsonMatcher, :type => :controller do
  let(:do_request) { get :show, :id => 1, :format => :json }
  let(:resource)   { { :one => 1, :two => 2 } }

  before do
    @controller.stub(:resource).and_return(resource)
    do_request
    expect(response.body).to eq(resource.to_json)
  end

  context "provided a Hash representing the expected JSON" do
    it "accepts exact matches" do
      expect(response).to send_json(resource)
    end

    it "accepts valid matches with re-ordered pairs" do
      expect(response).to send_json({ :two => 2, :one => 1})
    end

    it "rejects invalid matches" do
      expect(response).to_not send_json({})
      expect(response).to_not send_json({ :one => 2, :two => 1 })
      expect(response).to_not send_json(resource.to_json)
    end

    it "provides a helpful description" do
      matcher = send_json({ :one => '01', :two => '02' })
      expect(matcher.description).to eq('send JSON: (provided)')
    end
  end

  context "provided a String representing a JSON fixture lookup" do
    let(:name) { 'example/simple' }

    it "accepts valid matches" do
      expect(response).to send_json(name)
      expect(response).to send_json("#{name}.json")
    end

    it "rejects invalid matches" do
      expect(response).to_not send_json('example/bogus')
    end

    it "provides a helpful description" do
      matcher = send_json(name)
      expect(matcher.description).to eq('send JSON: example/simple.json')
    end
  end

  context "provided something other than a Hash or String" do
    it "raises an exception" do
      expect { send_json(:symbol) }.to raise_error(ArgumentError)
    end
  end

  context "given JSON with the `$extends` keyword" do
    let(:resource) { { :one => 1, :two => 2, :addition => 'more' } }

    it "accepts valid matches" do
      expect(response).to send_json('example/extend-success')
      expect(response).to send_json('example/extend-array')
    end

    it "rejects valid matches" do
      expect(response).to_not send_json('example/extend-failure')
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

    controller do
      respond_to :json

      def self.name
        'ExamplesController'
      end

      def show
        respond_with(resource)
      end
    end

    def get(action, params = {})
      with_routing do |map|
        map.draw do
          match 'examples/:id' => 'examples#show'
        end

        super(action, params)
      end
    end

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

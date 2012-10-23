require "spec_helper"

describe Emerson do
  let(:features) { Emerson.features }

  around do |example|
    with_features(features) { example.run }
  end

  describe ".responder_enabled?" do
    context "with the default feature set" do
      it "returns true" do
        expect(Emerson).to be_responder_enabled
      end
    end

    context "when the configured feature set is :all" do
      let(:features) { :all }

      it "returns true" do
        expect(Emerson).to be_responder_enabled
      end
    end

    context "when the configured feature set includes :responder" do
      let(:features) { [:responder] }

      it "returns true" do
        expect(Emerson).to be_responder_enabled
      end
    end

    context "when the configured feature set is nil" do
      let(:features) { nil }

      it "returns false" do
        expect(Emerson).to_not be_responder_enabled
      end
    end

    context "when the configured feature set is false" do
      let(:features) { false }

      it "returns false" do
        expect(Emerson).to_not be_responder_enabled
      end
    end

    context "when the configured feature set is []" do
      let(:features) { [] }

      it "returns false" do
        expect(Emerson).to_not be_responder_enabled
      end
    end
  end

  describe ".scope_enabled?" do
    context "with the default feature set" do
      it "returns true" do
        expect(Emerson).to be_scope_enabled
      end
    end

    context "when the configured feature set is :all" do
      let(:features) { :all }

      it "returns true" do
        expect(Emerson).to be_scope_enabled
      end
    end

    context "when the configured feature set includes :scope" do
      let(:features) { [:scope] }

      it "returns true" do
        expect(Emerson).to be_scope_enabled
      end
    end

    context "when the configured feature set is nil" do
      let(:features) { nil }

      it "returns false" do
        expect(Emerson).to_not be_scope_enabled
      end
    end

    context "when the configured feature set is false" do
      let(:features) { false }

      it "returns false" do
        expect(Emerson).to_not be_scope_enabled
      end
    end

    context "when the configured feature set is []" do
      let(:features) { [] }

      it "returns false" do
        expect(Emerson).to_not be_scope_enabled
      end
    end
  end
end

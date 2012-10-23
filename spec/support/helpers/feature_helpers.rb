module Support
  module FeatureHelpers
    def with_features(enabled, &block)
      originals = Emerson.features
      Emerson.features = enabled

      yield

      Emerson.features = originals
    end
  end
end

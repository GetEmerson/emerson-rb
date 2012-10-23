if defined?(RSpec)
  require 'emerson/matchers/integrations/rspec'
else
  require 'emerson/matchers/integrations/test_unit'
end

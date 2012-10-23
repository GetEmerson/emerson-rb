$:.push File.expand_path("../lib", __FILE__)

require "emerson/version"

Gem::Specification.new do |s|
  s.name          = "emerson"
  s.version       = Emerson::VERSION
  s.authors       = ["Corey Innis"]
  s.email         = ["corey@coolerator.net"]
  s.homepage      = "https://github.com/coreyti/emerson"
  s.summary       = %q{transcendent views}
  s.description   = %q{emerson believes in the inherent good in...}

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "jquery-rails" # for now.

  s.add_development_dependency "capybara"
  s.add_development_dependency "coffee-script"
  s.add_development_dependency "ffaker"
  s.add_development_dependency "jasmine"
  s.add_development_dependency "jasminerice"
  s.add_development_dependency "jasminerice-runner"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end

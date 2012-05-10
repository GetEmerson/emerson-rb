# -*- encoding: utf-8 -*-
require File.expand_path('../lib/emerson/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Corey Innis"]
  gem.email         = ["corey@coolerator.net"]
  gem.description   = %q{transcendent views}
  gem.summary       = %q{emerson believes in the inherent good in...}
  gem.homepage      = "https://github.com/coreyti/emerson"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "emerson"
  gem.require_paths = ["lib"]
  gem.version       = Emerson::VERSION
end

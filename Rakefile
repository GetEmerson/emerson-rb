#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  exit 1
end

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = '--color --format progress'
  t.verbose = false
end

desc 'Default: run specs'
task :default => [:spec]

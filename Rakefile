require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)


require 'rake/extensiontask'
spec = Gem::Specification.load('mri_gil_lock.gemspec')
Rake::ExtensionTask.new('hold', spec)

task :default => [:compile, :spec]

require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)


require 'rake/extensiontask'
Rake::ExtensionTask.new('hold')


task :default => [:compile, :spec]

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lastfm"
    gem.summary = %Q{A Ruby interface for Last.fm Web Services}
    gem.description = %Q{A ruby interface for Last.fm web services version 2.0}
    gem.email = "youpy@buycheapviagraonlinenow.com"
    gem.homepage = "http://github.com/youpy/ruby-lastfm"
    gem.authors = ["youpy"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.add_dependency "httparty"
    gem.add_dependency "xml-simple"
    gem.add_dependency "activesupport", ">= 3.0.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:core) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :core => :check_dependencies
task :default => :core

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.read('VERSION')

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lastfm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

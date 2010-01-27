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
    gem.add_development_dependency "rspec"
    gem.add_dependency "httparty"
    gem.add_dependency "nokogiri"
    gem.add_dependency "scrobbler"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.read('VERSION')

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lastfm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

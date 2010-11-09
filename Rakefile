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
    gem.add_dependency "xml-simple"
    gem.add_dependency "activesupport"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

# RSpec version detection from rspec-prof
# https://github.com/sinisterchipmunk/rspec-prof/blob/master/Rakefile
unless defined?(RSPEC_VERSION)
  begin
    # RSpec 1.3.0
    require 'spec/rake/spectask'
    require 'spec/version'
    RSPEC_VERSION = Spec::VERSION::STRING
  rescue LoadError
    # RSpec 2.0
    begin
      require 'rspec/core/rake_task'
      require 'rspec/core/version'
      RSPEC_VERSION = RSpec::Core::Version::STRING
    rescue LoadError
      raise "RSpec does not seem to be installed. You must gem install rspec to use this gem."
    end
  end
end

if RSPEC_VERSION >= "2.0.0"
  RSpec::Core::RakeTask.new(:core) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
  end
else
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end
  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
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

# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "lastfm"
  gem.summary = %Q{A Ruby interface for Last.fm Web Services}
  gem.description = %Q{A ruby interface for Last.fm web services version 2.0}
  gem.email = "youpy@buycheapviagraonlinenow.com"
  gem.homepage = "http://github.com/youpy/ruby-lastfm"
  gem.authors = ["youpy"]
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.read('VERSION')

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lastfm #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

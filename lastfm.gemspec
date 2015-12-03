# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["youpy"]
  gem.email         = ["youpy@buycheapviagraonlinenow.com"]
  gem.description   = "A ruby interface for Last.fm web services version 2.0"
  gem.summary       = "A ruby interface for Last.fm web services version 2.0"
  gem.homepage      = %q{http://github.com/youpy/ruby-lastfm}

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = %q{lastfm}
  gem.require_paths = ["lib"]
  gem.version       = "1.27.1"
  gem.license       = 'MIT'

  gem.add_dependency "xml-simple"
  gem.add_dependency "httparty"
  gem.add_dependency 'activesupport', '>= 3.2.0'

  gem.add_development_dependency('rspec', ['~> 2.8.0'])
  gem.add_development_dependency('rake')
end

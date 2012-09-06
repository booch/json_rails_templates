# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "json_rails_templates/version"

Gem::Specification.new do |s|
  s.name        = "json_rails_templates"
  s.version     = JsonRailsTemplates::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Craig Buchek']
  s.email       = ['craig@boochtek.com']
  s.homepage    = "http://github.com/boochtek/#{s.name}"
  s.summary     = %q{Rails view handler for generating JSON}
  s.description = %q{Rails view handler for easily generating JSON from view templates}

  s.rubyforge_project = "json_rails_templates"

  s.add_dependency 'actionpack', '~> 3.2.8'

  s.add_development_dependency 'rspec', '~> 2.11'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

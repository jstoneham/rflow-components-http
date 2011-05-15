# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rflow/components/http/version"

Gem::Specification.new do |s|
  s.name        = "rflow-components-http"
  s.version     = RFlow::Components::HTTP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '1.9.2'
  s.authors     = ["Michael L. Artz"]
  s.email       = ["michael.artz@redjack.com"]
  s.homepage    = ""
  s.summary     = %q{HTTP client and server components for the RFlow FBP framework}
  s.description = %q{HTTP client and server components for the RFlow FBP framework.  Also includes the necessary HTTP::Request and HTTP::Response message types}

  s.rubyforge_project = "rflow-components-http"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rflow', '= 0.0.1'
  s.add_dependency 'eventmachine_httpserver', '= 0.2.1'

  s.add_development_dependency 'rspec', '= 2.5.0'
  s.add_development_dependency 'rake', '= 0.8.7'
end

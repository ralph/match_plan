# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'match_plan/version'

Gem::Specification.new do |s|
  s.name        = 'match_plan'
  s.version     = MatchPlan::VERSION
  s.authors     = ['ralph']
  s.email       = ['ralph@rvdh.de']
  s.homepage    = ''
  s.summary     = %q{Specify tournament match plans with a dsl}
  s.description = %q{Specify tournament match plans with a dsl}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # specify any dependencies here; for example:
  s.add_development_dependency 'rake'
  # s.add_runtime_dependency "rest-client"
end

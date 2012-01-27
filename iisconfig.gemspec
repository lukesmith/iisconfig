# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "iisconfig/version"

Gem::Specification.new do |s|
  s.name        = "iisconfig"
  s.version     = IISConfig::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luke Smith"]
  s.email       = ["stuff@lukesmith.net"]
  s.homepage    = "https://github.com/lukesmith/iisconfig"
  s.summary     = "IIS Config"
  s.description = "IIS Configuration"

  s.rubyforge_project = "iisconfig"

  s.files         = `git ls-files -- {*/**/*,VERSION}`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = "lib"
  s.bindir        = 'bin'

  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "rainbow"

  s.add_development_dependency 'bozo'
end

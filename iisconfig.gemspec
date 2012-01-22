# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "iisconfig/iisconfig"

Gem::Specification.new do |s|
  s.name        = "iisconfig"
  s.version     = File.read('VERSION').strip
  s.authors     = ["Luke Smith"]
  s.email       = ["stuff@lukesmith.net"]
  s.homepage    = "https://github.com/lukesmith/iisconfig"
  s.summary     = "IIS Config"
  s.description = "IIS Configuration"

  s.rubyforge_project = "iisconfig"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "rainbow"
end

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

  s.files         = Dir['lib/**/*'] + Dir['VERSION']
  s.test_files    = Dir['test/**/*']
  s.executables   = 'iisconfig'
  s.require_path  = "lib"
  s.bindir        = 'bin'

  s.add_runtime_dependency "rainbow", "~> 3.0.0"
  s.add_runtime_dependency 'gli', '~> 2.18.0', '>= 2.18.0'
end

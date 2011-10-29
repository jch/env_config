# -*- encoding: utf-8 -*-
require File.expand_path('../lib/env_config/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jerry Cheung"]
  gem.email         = ["jch@whatcodecraves.com"]
  gem.description   = "Simple configuration management with environment variables"
  gem.summary       = <<-SUM
    Inspired by how Heroku uses environment variables for configs, EnvConfig 
    is a no-magic gem for defining configs in yaml, and loading them into
    environment variables.
  SUM
  gem.homepage      = "https://github.com/jch/env_config"

  gem.executables   = %w(env_config)
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "env_config"
  gem.require_paths = ["lib"]
  gem.version       = EnvConfig::VERSION

  gem.add_development_dependency "fstest"
  gem.add_development_dependency "rake"
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/roxx/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Boy Maas"]
  gem.email         = ["boy.maas@gmail.com"]
  gem.description   = %q{A small dsl to render audio mixes using the ecasound commandline tool.}
  gem.summary       = %q{DSL to render audiofiles}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "roxx"
  gem.require_paths = ["lib"]
  gem.version       = Roxx::VERSION
end

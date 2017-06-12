# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jif/version"

Gem::Specification.new do |spec|
  spec.name          = "jif"
  spec.version       = Jif::VERSION
  spec.authors       = ["Adam R Melnyk"]
  spec.email         = ["adam.melnyk@gmail.com"]

  spec.summary       = %q{Gif analyzer for editing and building gifs}
  spec.description   = %q{Gif analyzer for editing and building gifs written in ruby and dependencies free}
  spec.homepage      = "https://github.com/adamrmelnyk/jif"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radiation/version'

Gem::Specification.new do |spec|
  spec.name          = "radiation"
  spec.version       = Radiation::VERSION
  spec.authors       = ["Jan Mayer"]
  spec.email         = ["jan.mayer@ikp.uni-koeln.de"]
  spec.description   = %q{Decay Radiation}
  spec.summary       = %q{This gem provides easy access to energies and intensities from the decay of radioactive nuclei}
  spec.homepage      = "https://github.com/janmayer/radiation"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "plusminus"
  spec.add_dependency "open-uri-cached"
  spec.add_dependency "combinatorics"
  spec.add_dependency "linefit"
  spec.add_dependency "xml-simple"
  spec.add_dependency "thor"

  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

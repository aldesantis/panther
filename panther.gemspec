# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panther/version'

Gem::Specification.new do |spec|
  spec.name          = 'panther'
  spec.version       = Panther::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'A lightweight architecture for Rails APIs.'
  spec.homepage      = 'https://github.com/alessandro1997/panther'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'reform-rails', '~> 0.1.2'
  spec.add_dependency 'dry-types', '~> 0.7.2'
  spec.add_dependency 'roar-rails', '~> 1.0.1'
  spec.add_dependency 'multi_json', '~> 1.12.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end

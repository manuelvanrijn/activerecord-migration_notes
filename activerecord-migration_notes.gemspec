# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/migration_notes/version'

Gem::Specification.new do |spec|
  spec.name          = 'activerecord-migration_notes'
  spec.version       = ActiveRecord::MigrationNotes::VERSION
  spec.authors       = ['Manuel van Rijn']
  spec.email         = ['manuel@manuelvanrijn.nl']

  spec.summary       = 'Add notes to your migrations, to explain additional steps to take for example'
  spec.description   = 'ActiveRecord Migration Notes hooks into the Rails migrations and monitors if the migrations contain a note methods that should be shown afterwards.'
  spec.homepage      = 'http://manuelvanrijn.nl'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'activerecord', '>= 4.2'
end

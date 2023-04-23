# frozen_string_literal: true

require_relative "lib/parqueteur/version"

Gem::Specification.new do |spec|
  spec.name          = "parqueteur"
  spec.version       = Parqueteur::VERSION
  spec.authors       = ["Julien D."]
  spec.email         = ["julien@pocketsizesun.com"]
  spec.license       = 'Apache-2.0'
  spec.summary       = 'Parqueteur - A Ruby gem that convert data to Parquet'
  spec.description   = 'Convert data to Parquet'
  spec.homepage      = 'https://github.com/pocketsizesun/parqueteur-ruby'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'red-parquet', '~> 11.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

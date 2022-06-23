# frozen_string_literal: true

require_relative "lib/idp_sdk_ruby/version"

Gem::Specification.new do |spec|
  spec.add_runtime_dependency "rest-client", "~> 2.1"
  spec.add_runtime_dependency "json", "~> 2.6"

  spec.name = "idp_sdk_ruby"
  spec.version = IdpSdkRuby::VERSION
  spec.authors = ["sihan"]
  spec.email = ["sihan.6estates@gmail.com"]

  spec.summary = "idp_sdk_ruby"
  spec.description = "idp_sdk_ruby"
  spec.homepage = "https://rubygems.org/gems/idp_sdk_ruby"
  spec.required_ruby_version = ">= 2.6.0"
  spec.files=["lib/idp_sdk_ruby.rb"]


  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

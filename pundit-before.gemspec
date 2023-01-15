# frozen_string_literal: true

require_relative "lib/pundit/before/version"

Gem::Specification.new do |spec|
  #
  ## INFORMATION
  #
  spec.name = "pundit-before"
  spec.version = Pundit::Before.version
  spec.summary = "Adds before hook to pundit policy classes"
  spec.homepage = "https://github.com/javierav/pundit-before"
  spec.license = "MIT"

  #
  ## OWNERSHIP
  #
  spec.authors = ["Javier Aranda"]
  spec.email = ["javier.aranda.varo@gmail.com"]

  #
  ## METADATA
  #
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/javierav/pundit-before/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "https://github.com/javierav/pundit-before/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  #
  ## GEM
  #
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.git)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #
  ## DOCUMENTATION
  #
  spec.extra_rdoc_files = %w[LICENSE README.md]
  spec.rdoc_options     = ["--charset=UTF-8"]

  #
  ## REQUIREMENTS
  #
  spec.required_ruby_version = ">= 2.7.0"

  #
  ## DEPENDENCIES
  #
  spec.add_dependency "pundit", ">= 2.0", "< 3.0"
end

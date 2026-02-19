require_relative "lib/microslop_one_drive/version"

Gem::Specification.new do |spec|
  spec.name = "microslop_one_drive"
  spec.version = MicroslopOneDrive::VERSION
  spec.authors = ["Bradley Marques"]
  spec.email = ["bradleyrcmarques@protonmail.com"]

  spec.summary = "Ruby client helpers for Microsoft Graph OneDrive/SharePoint API (drive items, delta, permissions)."
  spec.description = "Lightweight value objects and HTTP client for OneDrive delta sync, item metadata, and sharing permissions."
  spec.homepage = "https://github.com/haikucode/microslop_one_drive"
  spec.required_ruby_version = ">= 3.4.2"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.24"

  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "mocha", "~> 2"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rubocop", "~> 1"
end

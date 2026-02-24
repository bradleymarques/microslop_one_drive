require_relative "lib/microslop_one_drive/version"

Gem::Specification.new do
  it.name = "microslop_one_drive"
  it.version = MicroslopOneDrive::VERSION
  it.authors = ["Bradley Marques"]
  it.email = [""]

  it.license = "MIT"

  it.summary = "Ruby client helpers for Microsoft Graph OneDrive/SharePoint API (drive items, delta, permissions)."
  it.description = "Simple and lightweight client for Microsoft Graph OneDrive/SharePoint API."
  it.homepage = "https://github.com/bradleymarques/microslop_one_drive"
  it.required_ruby_version = ">= 3.4.2"
  it.metadata["homepage_uri"] = it.homepage
  it.metadata["source_code_uri"] = it.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  it.files = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  it.require_paths = ["lib"]
end

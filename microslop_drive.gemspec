require_relative "lib/microslop_one_drive/version"

Gem::Specification.new do
  it.name = "microslop_one_drive"
  it.version = MicroslopOneDrive::VERSION
  it.authors = ["Bradley Marques"]
  it.email = [""]

  it.license = "MIT"

  it.summary = "Simple and lightweight Ruby client for Microsoft Graph OneDrive/SharePoint API."
  it.description = "Simple and lightweight Ruby client for Microsoft Graph OneDrive/SharePoint API."
  it.homepage = "https://github.com/bradleymarques/microslop_one_drive"
  it.required_ruby_version = ">= 3.4.2"
  it.metadata["homepage_uri"] = it.homepage
  it.metadata["source_code_uri"] = it.homepage
  it.metadata["rubygems_mfa_required"] = "true"

  it.files = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  it.require_paths = ["lib"]

  it.add_dependency "httparty", "~> 0.24"
end

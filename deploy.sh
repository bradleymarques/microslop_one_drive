#!/bin/bash
cd "$(dirname "$0")"
version=$(ruby -e "load 'lib/microslop_one_drive/version.rb'; puts MicroslopOneDrive::VERSION")

read -r -p "About to build and deploy v$version. Do you wish to proceed? (y/N) " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborting."
  exit 1
fi

echo "Building and deploying v$version..."

git tag -a v$version -m "Release $version"
git push origin v$version

gem build microslop_one_drive.gemspec
sleep 1
gem push microslop_one_drive-$version.gem

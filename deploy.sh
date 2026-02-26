#!/bin/bash
cd "$(dirname "$0")"
version=$(ruby -e "load 'lib/microslop_one_drive/version.rb'; puts MicroslopOneDrive::VERSION")

git tag -a v$version -m "Release $version"
git push origin v$version

gem build microslop_drive.gemspec
sleep 1
gem push microslop_drive-$version.gem

#!/bin/bash

# Automated deploy script with Circle CI.

# Exit if any subcommand fails.
set -e

# Variables
ORIGIN_URL=`git config --get remote.origin.url`

echo "Started deploying"

# Checkout gh-pages branch.
if [ `git branch | grep gh-pages` ]
then
  git branch -D gh-pages
fi
git checkout -b gh-pages

# Build site.
node ./metalsmith.js

# Delete and move files.
find . -maxdepth 1 ! -name 'build' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;
mv build/* .
rm -R build/

# Push to gh-pages.
git config user.name "Hofftech CI Bot"
git config user.email "ci@hoff.tech"

git add -fA
git commit --allow-empty -m "$(git log -1 --pretty=%B) [ci skip]"
git push -f git@github.com:kenhoff/slides.hoff.tech.git gh-pages

# Move back to previous branch.
git checkout -

echo "Deployed Successfully!"

exit 0

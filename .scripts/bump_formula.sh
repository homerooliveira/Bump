#!/bin/bash
set -e

TAG=$(git describe --tags --abbrev=0)
echo "Last version: $TAG"

LAST_REVISION=$(git rev-list -n 1 $TAG)
echo "Last revision $LAST_REVISION"

echo "Set last tag, revision and version to Formula"
sed -i '' -e 's/\(tag => "\)[^"]*/\1'"$TAG"'/' \
-e 's/\(revision => "\)[^"]*/\1'"$LAST_REVISION"'/' \
-e 's/\(version "\)[^"]*/\1'"$TAG"'/' \
 Formula/bump.rb

echo "Add changes and push to git"
git add Formula/bump.rb
git commit -m "Bump Formula to $TAG"
git push origin HEAD:master
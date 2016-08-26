#!/bin/bash
set -e

#! Read files as UTF-8 by default
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

# Start up and forward arguments to Jekyll
# TODO avoid hardcoded version directory name

exec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/vendor/ruby/2.2.0/bin/jekyll" "$@"

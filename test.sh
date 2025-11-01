#!/bin/bash
set -e

# Initialize sentry-cli bash script monitoring.
eval "$(sentry-cli bash-hook)"

mkdir -p /tmp/image-test
cd /tmp/image-test

# Test git can initialize repo.
git init

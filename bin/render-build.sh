#!/usr/bin/env bash
# exit on error
set -o errexit

apt-get update && apt-get install -y libpq-dev
bundle install
RAILS_ENV=production bundle exec rails assets:precompile
bundle exec rails db:migrate
bundle exec rails db:seed
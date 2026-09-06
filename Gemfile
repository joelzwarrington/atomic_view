# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "codelog", github: "codus/codelog", branch: "master"
gem "rake", "~> 13.0"
gem "minitest", "~> 5.0"
gem "rspec", "~> 3.0"
gem "standard", "~> 1.21"

gem "rails", "~> 8.0.1"
gem "sqlite3"
gem "sprockets-rails"
gem "puma", ">= 5.0"

# Stimulus/Turbo aren't dependencies of atomic_view itself -- host apps bring
# their own (see each JS-backed component's "Host app setup" docs) -- but the
# dummy app's importmap pins `@hotwired/stimulus`/`@hotwired/stimulus-loading`
# to the local assets these gems vendor, so previews are interactive.
gem "stimulus-rails"
gem "turbo-rails"

gem "tailwindcss-rails", "~> 4.6"
gem "lookbook"
gem "view_component-form"

group :development do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "standardrb"
end

# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "codelog", github: "codus/codelog", branch: "master"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "standard", "~> 1.21"

gem "rails", "~> 8.0.1"
gem "sqlite3"
gem "sprockets-rails"
gem "puma", ">= 5.0"

gem "tailwindcss-rails", "4.3"
gem "lookbook"
gem "view_component-form"

group :development do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "standardrb"
end

# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "codelog", github: "codus/codelog", branch: "master"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "standard", "~> 1.21"

gem "rails", "~> 8.0.1"
gem "sprockets-rails"
gem "puma", ">= 5.0"

gem "tailwindcss-rails"
gem "lookbook"
gem "view_component-form", github: "joelzwarrington/view_component-form", branch: "without-autoload"

group :development do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "standardrb"
end

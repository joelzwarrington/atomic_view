# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "config/application"

Rails.application.load_tasks

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task default: %i[spec standard]

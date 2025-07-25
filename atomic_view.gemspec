# frozen_string_literal: true

require_relative "lib/atomic_view/version"

Gem::Specification.new do |spec|
  spec.name = "atomic_view"
  spec.version = AtomicView::VERSION
  spec.authors = ["Joel Warrington"]
  spec.email = ["joelw@hey.com"]

  spec.summary = "Component library built for Ruby on Rails with first-class support for ActionView using ViewComponent."
  spec.homepage = "https://github.com/joelzwarrington/atomic_view"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "homepage_uri" => "https://github.com/joelzwarrington/atomic_view",
    "changelog_uri" => "https://github.com/joelzwarrington/atomic_view/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/joelzwarrington/atomic_view",
    "bug_tracker_uri" => "https://github.com/joelzwarrington/atomic_view/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", 'LICENSE.txt', 'Rakefile', 'README.md']
  end

  spec.add_dependency "zeitwerk", "~> 2.7.2"
  spec.add_dependency "importmap-rails", '~> 2.0.1'
  spec.add_dependency "rails", "~> 8.0.1"
  spec.add_dependency "view_component", "~> 3.21"
  spec.add_dependency "tailwindcss-rails", "~> 4.3"
  spec.add_dependency "tailwind_merge", "~> 0.12"
  spec.add_dependency "heroicons", "~> 2.0"
end

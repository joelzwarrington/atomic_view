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

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ lookbook/ .git .circleci appveyor Procfile.dev])
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.6.17"
  spec.add_dependency "rails", "~> 7.2.0"
  spec.add_dependency "view_component", "~> 3.13"
  spec.add_dependency "tailwind_merge", "~> 0.12"
end

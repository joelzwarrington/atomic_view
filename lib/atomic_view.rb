# frozen_string_literal: true

require "rails"
require "view_component"
require "tailwind_merge"
require "heroicons"
require "view_component/form"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem

vcf_gem_dir = Gem::Specification.find_by_name("view_component-form").gem_dir
loader.push_dir File.join(vcf_gem_dir, "app", "components")
loader.push_dir File.join(vcf_gem_dir, "app", "components", "concerns")

loader.setup

# Component library built for Ruby on Rails with first-class support for ActionView using ViewComponent.
module AtomicView
end

ViewComponent::Form.configure do |config|
  config.parent_component = "AtomicView::Component"
end

loader.eager_load

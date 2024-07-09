# frozen_string_literal: true

require "rails"
require "view_component"
require_relative "atomic_view/version"
require_relative "atomic_view/component"
require_relative "atomic_view/components/button_component"

require_relative "atomic_view/railtie"

# Component library built for Ruby on Rails with first-class support for ActionView using ViewComponent.
module AtomicView
  class << self
    def preview_folder_path
      root_directory = File.dirname(__dir__)
      File.join(root_directory, "lib", "atomic_view", "components", "previews")
    end
  end
end

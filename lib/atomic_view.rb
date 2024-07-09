# frozen_string_literal: true

require_relative "atomic_view/version"

# Component library built for Ruby on Rails with first-class support for ActionView using ViewComponent.
module AtomicView
  class << self
    def preview_folder_path
      root_directory = File.dirname(__dir__)
      File.join(root_directory, "components", "previews")
    end
  end
end

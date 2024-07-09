# frozen_string_literal: true

module AtomicView
  module Helpers
    module FormTagHelper
      def button_tag(...)
        render Components::ButtonComponent.new(...)
      end
    end
  end
end

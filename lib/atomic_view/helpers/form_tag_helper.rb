# frozen_string_literal: true

module AtomicView
  module Helpers
    module FormTagHelper # rubocop:disable Style/Documentation
      extend ActiveSupport::Concern

      def button_tag(...)
        render Components::ButtonComponent.new(...)
      end
    end
  end
end

# frozen_string_literal: true

module AtomicView
  module Helpers
    module FormTagHelper # rubocop:disable Style/Documentation
      extend ActiveSupport::Concern

      def button_tag(*args, **kwargs, &block)
        render Components::ButtonComponent.new(*args, **kwargs, &block)
      end
    end
  end
end

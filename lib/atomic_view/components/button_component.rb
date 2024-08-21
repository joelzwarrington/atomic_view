# frozen_string_literal: true

module AtomicView
  module Components
    # Button
    class ButtonComponent < ViewComponent::Form::ButtonComponent
      attr_reader :label

      def initialize(form, label_or_options = nil, options = nil)
        super

        if label_or_options.is_a?(String)
          @label = label_or_options
        end
      end

      def call
        if content?
          content_tag(:button, @options) { content }
        else
          content_tag(:button, label, @options)
        end
      end
    end
  end
end

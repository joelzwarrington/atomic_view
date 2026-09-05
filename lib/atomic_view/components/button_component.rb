# frozen_string_literal: true

module AtomicView
  module Components
    # Button
    class ButtonComponent < ViewComponent::Form::ButtonComponent
      include AtomicView::Components::Concerns::ButtonVariants

      attr_reader :label, :variant, :size

      def initialize(form, label_or_options = nil, options = nil)
        super

        if label_or_options.is_a?(String)
          @label = label_or_options
          @options ||= {}
        elsif label_or_options.is_a?(Hash)
          @options = label_or_options
        end

        @variant = @options.delete(:variant) || :primary
      end

      def call
        @options[:class] = class_names(base_classes, variant_classes, @options[:class])

        if content?
          content_tag(:button, @options) { content }
        else
          content_tag(:button, label, @options)
        end
      end
    end
  end
end

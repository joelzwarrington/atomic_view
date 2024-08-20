# frozen_string_literal: true

module AtomicView
  module Components
    # Button
    class ButtonComponent < ViewComponent::Form::ButtonComponent
      # TODO: this is an example, should build out common system to handle size, variant, etc.

      attr_reader :label, :size, :variant

      def initialize(form, label_or_options = nil, options = nil)
        super

        if label_or_options.is_a?(Hash)
          options = label_or_options
        else
          @label = label_or_options
          options ||= {}
        end

        @variant = options.delete(:variant)
        @size = options.delete(:size) || :md

        options[:class] = opts_to_class
        @options = options
      end

      def call
        if content?
          content_tag(:button, @options) { content }
        else
          content_tag(:button, label, @options)
        end
      end

      private

      def opts_to_class
        class_names(
          # size
          {
            "rounded px-2.5 py-1.5 text-xs": size == :xs,
            "rounded px-2.5 py-1.5 text-sm": size == :sm,
            "rounded-md px-3 py-2 text-sm": size == :md,
            "rounded-md px-3.5 py-2.5 text-md": size == :lg
          },
          # variant
          {
            "text-white bg-primary shadow-sm ring-1 ring-inset ring-primary-800 hover:bg-primary-800": variant == :primary,
            "text-zinc-900 bg-secondary-50 shadow-sm ring-1 ring-inset ring-secondary-200 hover:bg-secondary-100": variant == :secondary,
            "text-zinc-900 hover:bg-secondary-100": variant == :tertiary
          }
        )
      end
    end
  end
end

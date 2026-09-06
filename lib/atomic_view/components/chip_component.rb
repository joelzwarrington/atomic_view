# frozen_string_literal: true

module AtomicView
  module Components
    class ChipComponent < AtomicView::Component
      attr_reader :dismissible, :dismiss_button_options, :leading

      def initialize(dismissible: false, dismiss_button_options: {}, leading: nil, **options)
        super()
        @dismissible = dismissible
        @dismiss_button_options = dismiss_button_options
        @leading = leading
        @options = options
      end

      def call
        tag.span(**@options.except(:class), class: class_names(base_classes, @options[:class])) do
          safe_join([leading, content, dismiss_button].compact)
        end
      end

      private

      def base_classes
        "inline-flex items-center gap-1 rounded-pill bg-offset px-2.5 py-1 text-xs font-medium text-foreground border border-border"
      end

      def dismiss_button
        return unless dismissible

        tag.button(**dismiss_button_options.except(:class), type: "button", class: class_names("inline-flex items-center", dismiss_button_options[:class])) do
          icon("x-mark", variant: :mini, options: {class: "size-3.5"}).to_s.html_safe
        end
      end
    end
  end
end

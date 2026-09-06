# frozen_string_literal: true

module AtomicView
  module Components
    # Chip
    #
    # A dismissible chip is automatically wired to `atomic-view--chip`, the
    # Stimulus controller that handles removing it from the DOM on click
    # (see `app/assets/javascripts/atomic_view/controllers/chip_controller.js`).
    # Pass `dismiss_button_options` only to customize that behavior, e.g. to
    # trigger a network request instead of (or in addition to) the default
    # remove animation.
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
        tag.span(**@options.except(:class, :data), class: class_names(base_classes, @options[:class]), data: data_attributes) do
          safe_join([leading, content, dismiss_button].compact)
        end
      end

      private

      def base_classes
        "inline-flex items-center gap-1 rounded-pill bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border"
      end

      def data_attributes
        attributes = (@options[:data] || {}).dup
        return attributes unless dismissible

        attributes[:controller] = [attributes[:controller], "atomic-view--chip"].compact.join(" ")
        attributes
      end

      def dismiss_button
        return unless dismissible

        options = dismiss_button_options.except(:class, :data)
        data = {action: "click->atomic-view--chip#remove"}.merge(dismiss_button_options[:data] || {})

        tag.button(**options, type: "button", data: data, class: class_names("inline-flex items-center", dismiss_button_options[:class])) do
          icon("x-mark", variant: :mini, options: {class: "size-3.5"}).to_s.html_safe
        end
      end
    end
  end
end

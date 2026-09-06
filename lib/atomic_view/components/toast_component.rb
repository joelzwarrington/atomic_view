# frozen_string_literal: true

module AtomicView
  module Components
    # Toast
    #
    # A single, self-dismissing notification. This component only renders
    # one toast and wires it to `atomic-view--toast`, the Stimulus controller
    # that handles its own dismiss/auto-dismiss lifecycle (see
    # `app/assets/javascripts/atomic_view/controllers/toast_controller.js`).
    #
    # Stacking multiple toasts (newest on top/bottom, fixed to a screen
    # corner) is intentionally out of scope -- wrap however many
    # ToastComponents a consuming app renders in a plain CSS container, e.g.
    # `fixed bottom-4 right-4 flex flex-col-reverse gap-2 z-50`.
    class ToastComponent < AtomicView::Component
      attr_reader :variant, :title, :description, :dismissible, :auto_dismiss_ms

      VARIANTS = {
        success: {icon: "check-circle", border: "border-l-success", icon_color: "text-success"},
        error: {icon: "x-circle", border: "border-l-destructive", icon_color: "text-destructive"},
        info: {icon: "information-circle", border: "border-l-primary", icon_color: "text-primary"}
      }.freeze

      def initialize(title:, variant: :info, description: nil, dismissible: true, auto_dismiss_ms: nil, **options)
        super()
        @variant = variant
        @title = title
        @description = description
        @dismissible = dismissible
        @auto_dismiss_ms = auto_dismiss_ms
        @options = options
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names(base_classes, variant_config[:border], @options[:class])
      end

      def icon_name
        variant_config[:icon]
      end

      def icon_class
        class_names("size-5 shrink-0", variant_config[:icon_color])
      end

      def data_attributes
        attributes = (@options[:data] || {}).merge(controller: "atomic-view--toast")
        attributes["atomic-view--toast-auto-dismiss-ms-value"] = auto_dismiss_ms if auto_dismiss_ms.present?
        attributes
      end

      private

      def variant_config
        VARIANTS.fetch(variant, VARIANTS[:info])
      end

      def base_classes
        "flex items-start gap-3 rounded-card border border-border border-l-4 bg-surface p-3 shadow-soft"
      end
    end
  end
end

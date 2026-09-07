# frozen_string_literal: true

module AtomicView
  module Components
    # Alert
    #
    # A persistent, inline banner for messages that belong in the page flow
    # rather than a transient corner notification -- form-level validation
    # summaries, page banners, billing warnings, etc. For a self-dismissing
    # notification instead, see ToastComponent.
    class AlertComponent < AtomicView::Component
      attr_reader :variant, :title

      VARIANTS = {
        info: {icon: "information-circle", classes: "border-info bg-info/10", text_class: "text-info"},
        success: {icon: "check-circle", classes: "border-success bg-success/10", text_class: "text-success"},
        warning: {icon: "exclamation-triangle", classes: "border-warning bg-warning/10", text_class: "text-warning"},
        error: {icon: "x-circle", classes: "border-destructive bg-destructive/10", text_class: "text-destructive"}
      }.freeze

      def initialize(variant: :info, title: nil, **options)
        super()
        @variant = variant
        @title = title
        @options = options
      end

      def html_options
        @options.except(:class)
      end

      def html_class
        class_names(base_classes, variant_config[:classes], @options[:class])
      end

      def icon_name
        variant_config[:icon]
      end

      def icon_class
        class_names("size-5 shrink-0", text_class)
      end

      def text_class
        variant_config[:text_class]
      end

      def content_class
        class_names("text-sm", text_class, "mt-1" => title.present?)
      end

      private

      def variant_config
        VARIANTS.fetch(variant, VARIANTS[:info])
      end

      def base_classes
        "border-l-4 p-3"
      end
    end
  end
end

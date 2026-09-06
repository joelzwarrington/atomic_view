# frozen_string_literal: true

module AtomicView
  module Components
    class BadgeComponent < AtomicView::Component
      attr_reader :variant

      def initialize(variant: :default, **options)
        super()
        @variant = variant
        @options = options
      end

      def call
        tag.span(**@options.except(:class), class: class_names(base_classes, variant_classes, @options[:class])) { content }
      end

      private

      def base_classes
        "inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium"
      end

      def variant_classes
        case variant
        when :secondary
          "bg-secondary text-secondary-foreground"
        when :destructive
          "bg-destructive text-destructive-foreground"
        when :outline
          "bg-transparent border border-border text-foreground"
        else
          "bg-primary text-primary-foreground"
        end
      end
    end
  end
end

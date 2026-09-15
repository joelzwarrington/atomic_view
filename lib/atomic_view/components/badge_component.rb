# frozen_string_literal: true

module AtomicView
  module Components
    # Badge
    #
    # A small rectangular status/label pill. `default`/`secondary` are solid
    # fills for general-purpose emphasis (a count, a category tag);
    # `success`/`warning`/`destructive`/`info` are soft, bordered/tinted
    # semantic colors for actual state (active/upcoming/cancelled/etc.) --
    # the same `border-x bg-x/10 text-x` treatment AlertComponent already
    # uses for its variants, just as a compact pill instead of a banner.
    # `outline` is the neutral, colorless version of that same bordered
    # style, for a status that doesn't map to any of the semantic colors.
    #
    # Every variant carries a `border` (transparent on the solid fills) so
    # badges of different variants sitting side by side stay the same
    # height regardless of which ones happen to have a visible border.
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
        "inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium"
      end

      def variant_classes
        case variant
        when :secondary
          "border-transparent bg-secondary text-secondary-foreground"
        when :destructive
          "border-destructive bg-destructive/10 text-destructive"
        when :success
          "border-success bg-success/10 text-success"
        when :warning
          "border-warning bg-warning/10 text-warning"
        when :info
          "border-info bg-info/10 text-info"
        when :outline
          "border-border bg-transparent text-foreground"
        else
          "border-transparent bg-primary text-primary-foreground"
        end
      end
    end
  end
end

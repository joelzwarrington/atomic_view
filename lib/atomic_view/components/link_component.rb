# frozen_string_literal: true

module AtomicView
  module Components
    # Link
    #
    # A button-styled anchor tag -- shares ButtonComponent's variants
    # (`primary`, `secondary`, `destructive`, `muted`, `link`, `outline`) via
    # the same ButtonVariants concern, so a navigational action (e.g. "New
    # record") can sit next to real buttons without looking out of place.
    #
    # `keybinds:`, when given (a single key, or an array for a chord --
    # same convention as `CommandPaletteComponent::RowComponent#hint`),
    # renders a KbdComponent per key after the content, as a visual hint.
    # Wiring the actual keydown-to-click behavior is left to the host app
    # (e.g. a Stimulus controller on the anchor).
    class LinkComponent < AtomicView::Component
      include AtomicView::Components::Concerns::ButtonVariants

      attr_reader :href, :variant, :keybinds

      def initialize(href, variant: :primary, keybinds: nil, **options)
        super()
        @href = href
        @variant = variant
        @keybinds = Array(keybinds)
        @options = options
      end

      def html_options
        @options.except(:class).merge(class: html_class)
      end

      def html_class
        class_names(base_classes, variant_classes, @options[:class])
      end
    end
  end
end

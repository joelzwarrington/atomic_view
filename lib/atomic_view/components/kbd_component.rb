# frozen_string_literal: true

module AtomicView
  module Components
    # Kbd
    #
    # A single keyboard "keycap" token -- a modifier symbol (⌘), a letter
    # (K), or a named key (Esc). It's a generic, content-based primitive
    # (like BadgeComponent/ChipComponent) rather than something that knows
    # about multi-key shortcuts -- to show a full chord, render several
    # inside a flex container with a small gap, adding a `+` between them
    # if the convention calls for it (see CommandPaletteComponent for an
    # example, or the preview's "Composing a shortcut" examples).
    class KbdComponent < AtomicView::Component
      def initialize(**options)
        super()
        @options = options
      end

      def call
        tag.kbd(**@options.except(:class), class: class_names(base_classes, @options[:class])) { content }
      end

      private

      def base_classes
        "inline-flex h-5 min-w-5 items-center justify-center rounded-well border border-border bg-offset px-1 font-mono text-xs text-muted-foreground"
      end
    end
  end
end

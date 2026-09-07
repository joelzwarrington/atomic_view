module Display
  class KbdComponentPreview < Lookbook::Preview
    # Single key
    # ----------
    # The generic building block -- a modifier symbol, a letter, or a
    # named key like `Esc`. Content-based, like BadgeComponent/ChipComponent,
    # so it renders whatever's given.
    #
    # @param key text "The key label to display"
    def single(key: "Esc")
      render(AtomicView::Components::KbdComponent.new) { key }
    end

    # @!group Composing a shortcut

    # Adjacent keys
    # -------------
    # It doesn't know about multi-key shortcuts itself -- combine several
    # inside a flex container with a small gap instead. Adjacent, ungapped
    # keys read as a chord the Mac way (⌘⇧K).
    def adjacent
      render_with_template
    end

    # Separated keys
    # --------------
    # Add a `+` between keys for the Windows/Linux convention instead
    # (Ctrl+B).
    def separated
      render_with_template
    end

    # @!endgroup
  end
end

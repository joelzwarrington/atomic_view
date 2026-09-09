module Display
  class LinkComponentPreview < Lookbook::Preview
    # @!group Variants

    # Primary
    # -------
    # The default call-to-action style, shared with `ButtonComponent`. Use
    # it for a navigational action that's the single most important thing
    # to do next -- e.g. "New record" -- where a real `<button>` isn't
    # appropriate because it just links somewhere.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def primary(content: "New record", href: "#")
      render(AtomicView::Components::LinkComponent.new(href)) { content }
    end

    # Secondary
    # ---------
    # A lower-emphasis action placed alongside a primary link or button.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def secondary(content: "Cancel", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, variant: :secondary)) { content }
    end

    # Destructive
    # -----------
    # Signals a dangerous, hard-to-reverse action reached via navigation
    # (e.g. a confirmation page) rather than an in-place `<button>`.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def destructive(content: "Delete", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, variant: :destructive)) { content }
    end

    # Muted
    # -----
    # A quiet, low-visual-weight link for auxiliary actions -- an inline
    # "Edit" link in a toolbar or table row.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def muted(content: "Edit", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, variant: :muted)) { content }
    end

    # Link
    # ----
    # Renders like an inline text link rather than a button.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def link(content: "Learn more", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, variant: :link)) { content }
    end

    # Outline
    # -------
    # A bordered, transparent-background style.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def outline(content: "View details", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, variant: :outline)) { content }
    end

    # @!endgroup

    # @!group Keybinds

    # Single keybind
    # --------------
    # Pass `keybinds:` to append a `KbdComponent` hint after the label --
    # purely visual; the host app is responsible for wiring the actual
    # keyboard shortcut (e.g. a Stimulus controller on the anchor).
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def with_keybind(content: "New record", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, keybinds: "N")) { content }
    end

    # Chord of keybinds
    # -----------------
    # Pass an array to render several keys, e.g. for a modifier chord.
    #
    # @param content text "The link's label"
    # @param href text "The link's destination"
    def with_keybind_chord(content: "Search", href: "#")
      render(AtomicView::Components::LinkComponent.new(href, keybinds: ["⌘", "K"])) { content }
    end

    # @!endgroup
  end
end

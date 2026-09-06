module Display
  class BadgeComponentPreview < Lookbook::Preview
    # @!group Variants

    # Primary Badge
    # -------
    # The standard badge style, using the `primary` color. Reach for this as
    # the default choice whenever you need to highlight a status, count, or
    # label and no other variant's meaning applies.
    #
    # @param content text "The text to display in the badge"
    def primary(content: "Primary")
      render AtomicView::Components::BadgeComponent.new do
        content
      end
    end

    # Secondary Badge
    # ---------
    # A lower-emphasis, muted style. Use it for auxiliary metadata that
    # shouldn't compete with the primary content on the page — e.g. a
    # category tag or a count that's informational rather than actionable.
    #
    # @param content text "The text to display in the badge"
    def secondary(content: "Secondary")
      render AtomicView::Components::BadgeComponent.new(variant: :secondary) do
        content
      end
    end

    # Destructive Badge
    # -----------
    # Signals an error, warning, or a state that needs attention — failed
    # jobs, overdue items, or anything the user should treat as a problem.
    # Avoid using it purely for visual emphasis; reserve the red for actual
    # negative states so it keeps its meaning.
    #
    # @param content text "The text to display in the badge"
    def destructive(content: "Destructive")
      render AtomicView::Components::BadgeComponent.new(variant: :destructive) do
        content
      end
    end

    # Outline Badge
    # -------
    # A transparent, bordered style with the least visual weight. Good for
    # dense lists of tags/filters where several badges appear together and
    # a solid fill would be too heavy, or for placing a badge on top of a
    # colored/image background.
    #
    # @param content text "The text to display in the badge"
    def outline(content: "Outline")
      render AtomicView::Components::BadgeComponent.new(variant: :outline) do
        content
      end
    end

    # @!endgroup
  end
end

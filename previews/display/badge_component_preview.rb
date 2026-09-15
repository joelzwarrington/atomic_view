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

    # Success Badge
    # -------------
    # A soft green, bordered/tinted style for a positive or "in good
    # standing" state — active, confirmed, paid.
    #
    # @param content text "The text to display in the badge"
    def success(content: "Active")
      render AtomicView::Components::BadgeComponent.new(variant: :success) do
        content
      end
    end

    # Warning Badge
    # -------------
    # A soft amber, bordered/tinted style for a state that isn't wrong but
    # deserves a second look — upcoming, pending, expiring soon.
    #
    # @param content text "The text to display in the badge"
    def warning(content: "Upcoming")
      render AtomicView::Components::BadgeComponent.new(variant: :warning) do
        content
      end
    end

    # Destructive Badge
    # -----------
    # A soft red, bordered/tinted style. Signals an error, a cancellation,
    # or a state that needs attention — failed jobs, overdue items, or
    # anything the user should treat as a problem. Avoid using it purely for
    # visual emphasis; reserve the red for actual negative states so it
    # keeps its meaning.
    #
    # @param content text "The text to display in the badge"
    def destructive(content: "Cancelled")
      render AtomicView::Components::BadgeComponent.new(variant: :destructive) do
        content
      end
    end

    # Info Badge
    # ----------
    # A soft blue, bordered/tinted style for a neutral, informational
    # status that isn't a warning or an error.
    #
    # @param content text "The text to display in the badge"
    def info(content: "Draft")
      render AtomicView::Components::BadgeComponent.new(variant: :info) do
        content
      end
    end

    # Outline Badge
    # -------
    # A transparent, neutrally-bordered style with the least visual weight —
    # the colorless version of the semantic variants above. Good for a
    # status that doesn't map to any of them (e.g. "Completed"), for dense
    # lists of tags/filters where several badges appear together, or for
    # placing a badge on top of a colored/image background.
    #
    # @param content text "The text to display in the badge"
    def outline(content: "Completed")
      render AtomicView::Components::BadgeComponent.new(variant: :outline) do
        content
      end
    end

    # @!endgroup
  end
end

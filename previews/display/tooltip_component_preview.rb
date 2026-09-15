module Display
  class TooltipComponentPreview < Lookbook::Preview
    # @!group Examples

    # Text label
    # ----------
    # `text:` covers the common case -- a short plain-text label shown on
    # hover/focus of the trigger. Positioning uses `@floating-ui/dom`, pinned
    # via importmap (same as `DropdownComponent` -- no host app setup needed
    # beyond the standard `eagerLoadControllersFrom("controllers",
    # application)` boilerplate).
    def text_label
      render_with_template
    end

    # Placement
    # ---------
    # Pass `placement:` (`"top"`, `"bottom"`, `"left"`, or `"right"`) to
    # anchor the tooltip on a different side of the trigger. Edge-aware
    # flip/shift middleware keeps it on-screen near a viewport edge
    # regardless of the requested placement.
    def placement
      render_with_template
    end

    # Icon-only trigger
    # ------------------
    # A common pairing: an icon-only button (e.g. a toolbar action, or a
    # collapsed `NavigationTreeComponent` item) that would otherwise have no
    # visible label.
    def icon_only_trigger
      render_with_template
    end

    # Rich content
    # ------------
    # Pass a `body` slot instead of `text:` for anything richer than
    # plain text.
    def rich_content
      render_with_template
    end

    # Max width
    # ---------
    # The bubble defaults to `max-w-xs` (20rem), which can wrap longer text
    # tightly even when there's plenty of room on screen. Pass
    # `content_class:` to widen it (or otherwise restyle the bubble) -- it's
    # merged via TailwindMerge, so a conflicting `max-w-*` replaces the
    # default instead of fighting it. This is a separate option from
    # `class:`, which targets the outer trigger wrapper rather than the
    # floating bubble.
    def max_width
      render_with_template
    end

    # @!endgroup
  end
end

module Display
  class ChipComponentPreview < Lookbook::Preview
    # @!group Examples

    # Chip
    # ----
    # A compact pill for a single piece of tag-like metadata — a filter, a
    # category, or a short label attached to an item. Use it inline, in
    # groups, wherever you'd otherwise reach for a small piece of
    # freestanding text that needs to stand out slightly from its
    # surroundings.
    #
    # @param content text "The text to display in the chip"
    def default(content: "Filter")
      render AtomicView::Components::ChipComponent.new do
        content
      end
    end

    # Chip with leading icon
    # ----------------------
    # Add a `leading` element (typically a small Heroicon) when the chip's
    # text alone doesn't make its category obvious at a glance — e.g. a
    # location, a file type, or a status. Keep the icon small (`size-3.5`)
    # so it doesn't overpower the text.
    #
    # @param content text "The text to display in the chip"
    def with_leading_icon(content: "Site ER")
      leading = Heroicons::Icon.render(name: "map-pin", variant: :mini, options: {class: "size-3.5"}, path_options: {}).to_s.html_safe

      render AtomicView::Components::ChipComponent.new(leading: leading) do
        content
      end
    end

    # Dismissible chip
    # ----------------
    # Set `dismissible: true` when the chip represents something the user
    # can remove — an applied filter, a selected item in a multi-select.
    # The trailing "x" button is automatically wired to remove the chip on
    # click; pass `dismiss_button_options` only if you need to customize
    # that behavior (e.g. trigger a network request instead).
    #
    # @param content text "The text to display in the chip"
    def dismissible(content: "Removable")
      render AtomicView::Components::ChipComponent.new(dismissible: true) do
        content
      end
    end

    # @!endgroup
  end
end

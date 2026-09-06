module Display
  class CardComponentPreview < Lookbook::Preview
    # Card
    # ----
    # A generic surface container for grouping related content — use it to
    # visually separate a section of a page (a panel, a summary, a list
    # item) from the page background. It doesn't imply any particular
    # content model, so it's a good default wrapper whenever you need a
    # bordered, padded block but don't need a more specific component.
    #
    # Turn on `hoverable` when the whole card is a single clickable/tappable
    # target (e.g. it's wrapped in a link) — the shadow transition gives a
    # hint that it's interactive. Leave it off for purely static content, so
    # you don't imply interactivity that isn't there.
    #
    # @param hoverable toggle "Adds a hover shadow transition — use only when the whole card is clickable"
    # @param title text "The card's heading"
    # @param body textarea "The card's body copy"
    def default(hoverable: false, title: "Card title", body: "Some placeholder content that lives inside a card.")
      render AtomicView::Components::CardComponent.new(hoverable: hoverable) do
        tag.h3(title, class: "text-sm font-medium text-foreground") +
          tag.p(body, class: "mt-1 text-sm text-muted-foreground")
      end
    end
  end
end

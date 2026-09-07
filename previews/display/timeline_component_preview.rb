module Display
  class TimelineComponentPreview < Lookbook::Preview
    # Timeline
    # --------
    # A vertical audit/activity feed for a record's history — created,
    # changed, auto-updated, and commented events all share the same
    # marker + meta-line layout, with a connecting line down the left
    # edge. Items are `with_item` slots (see `TimelineComponent`'s class
    # docs for the keyword arguments); the block passed to `with_item`
    # carries whatever varies too much to model as a keyword argument — a
    # diff comparison, a status-change badge pair, a comment bubble.
    # `time:` takes a real `Time` -- rendered via the `local_time` gem's
    # `local_time_ago` helper, which ages from "3 hours ago" into a full
    # date on its own, so there's no need to pick relative vs. absolute
    # phrasing per item here.
    def default
      render(AtomicView::Components::TimelineComponent.new) do |timeline|
        timeline.with_item(
          icon: "flag",
          actor: "Joel W",
          description: "created this park",
          time: 1.year.ago
        )

        timeline.with_item(
          icon: "arrow-path",
          actor: "Joel W",
          description: "changed the tax code",
          time: 3.months.ago
        ) { diff_content("HST NS 2024", "HST NS 2025") }

        timeline.with_item(
          icon: "arrow-path",
          description: "Status changed automatically",
          time: 3.days.ago
        ) { diff_content("Needs attention", "Active") }

        timeline.with_item(
          avatar: "JW",
          actor: "Joel W",
          description: "commented",
          time: 3.hours.ago
        ) { comment_bubble("Following up with QuickBooks support about the sync delay on last month's invoices.") }

        timeline.with_item(
          avatar: "CS",
          actor: "Camped Support",
          description: "commented",
          time: 1.hour.ago
        ) { comment_bubble("Reached out to QuickBooks on your behalf — sync should resume within 24 hours.") }
      end
    end

    private

    def diff_content(from, to)
      tag.div(class: "mt-2 flex items-center gap-2") do
        tag.span(from, class: "rounded-well bg-offset px-2 py-0.5 font-mono text-xs text-muted-foreground") +
          Heroicons::Icon.render(name: "arrow-right", variant: :mini, options: {class: "size-3.5 text-muted-foreground"}, path_options: {}).to_s.html_safe +
          tag.span(to, class: "rounded-well bg-offset px-2 py-0.5 font-mono text-xs text-muted-foreground")
      end
    end

    def comment_bubble(text)
      tag.div(text, class: "mt-2 rounded-btn bg-offset p-2.5 text-sm text-foreground")
    end
  end
end

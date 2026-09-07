module Display
  class TabsComponentPreview < Lookbook::Preview
    # Tabs
    # ----
    # An underlined tab bar for navigating between a record's sub-pages —
    # e.g. Overview/Invoices/Activity on a park's detail page. `selected`
    # is matched against each option's `label:`, since the caller already
    # has the current tab's display value on hand (typically derived from
    # the request path) rather than a form value.
    #
    # @param selected select { choices: [Overview, Invoices, "Meter readings", Activity] }
    def default(selected: "Activity")
      render(AtomicView::Components::TabsComponent.new(
        options: [
          {label: "Overview", href: "#"},
          {label: "Invoices", href: "#"},
          {label: "Meter readings", href: "#"},
          {label: "Activity", href: "#"}
        ],
        selected: selected
      ))
    end

    # With turbo_frame
    # ----------------
    # Pass `turbo_frame:` and give the content area a matching
    # `<turbo-frame id="...">` to swap tabs without a full page load —
    # click a tab below and only the frame's content changes. This demo
    # links between two Lookbook preview scenarios (each a real page
    # load) to show it working end-to-end; Turbo only needs a matching
    # frame `id` somewhere in the response, not a special partial-only
    # route.
    def turbo_frame_overview
      render_with_template(locals: {selected: "Overview"})
    end

    # Invoices
    # --------
    # The other half of the `turbo_frame` demo above — switch back and
    # forth between this and "With turbo_frame" and only the panel below
    # the tabs re-renders.
    def turbo_frame_invoices
      render_with_template(locals: {selected: "Invoices"}, template: "display/tabs_component_preview/turbo_frame_overview")
    end
  end
end

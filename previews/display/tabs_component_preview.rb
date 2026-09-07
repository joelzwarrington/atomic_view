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
  end
end

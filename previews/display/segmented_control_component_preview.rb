module Display
  class SegmentedControlComponentPreview < Lookbook::Preview
    # @!group Modes

    # Link mode
    # ---------
    # Renders each option as a plain `<a>` — use it for filter tabs where
    # the "selected" state just reflects the current request's query
    # string (e.g. `?filter=active`), not a form value. `selected` is
    # matched against each option's `label:`, since the caller already has
    # the current filter's display value on hand (`params[:filter]`).
    #
    # @param selected select { choices: [All, Active, "Needs attention"] }
    def link_mode(selected: "Active")
      render(AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "All", href: "#"},
          {label: "Active", href: "#"},
          {label: "Needs attention", href: "#"}
        ],
        selected: selected
      ))
    end

    # Radio mode
    # ----------
    # Renders each option as a real `<input type="radio">` + `<label>`
    # pair (visually styled as the same pill track as link mode) — use it
    # when the choice is an actual form value that submits with the rest
    # of the form, not just a navigation filter. `name:` is required and
    # becomes every radio's `name` attribute; `selected` is matched
    # against each option's `value:`.
    #
    # The panel below is revealed with a pure CSS `:has()` sibling check —
    # no JS required — when "Seasonal" is selected.
    #
    # @param selected select { choices: [monthly, seasonal] }
    def radio_mode(selected: "monthly")
      render_with_template(locals: {selected: selected})
    end

    # @!endgroup
  end
end

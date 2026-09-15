# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ChipComponentTest < ViewComponent::TestCase
  test "renders a plain chip by default" do
    actual = render_inline(AtomicView::Components::ChipComponent.new) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center gap-1 rounded-btn bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border">Filter</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders leading content before the main content" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(leading: "<span class=\"dot\"></span>".html_safe)) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center gap-1 rounded-btn bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border"><span class="dot"></span>Filter</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders a trailing dismiss button when dismissible" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(dismissible: true)) { "Filter" }.to_html.strip

    assert_includes(actual, "<button type=\"button\"")
    assert_includes(actual, "<svg")
    assert_includes(actual, "size-3.5")
  end

  test "does not render a dismiss button by default" do
    actual = render_inline(AtomicView::Components::ChipComponent.new) { "Filter" }.to_html.strip

    assert_not_includes(actual, "<button")
  end

  test "automatically wires the dismiss Stimulus controller and action when dismissible" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(dismissible: true)) { "Filter" }.to_html.strip

    assert_includes(actual, "data-controller=\"atomic-view--chip\"")
    assert_includes(actual, "data-action=\"click->atomic-view--chip#remove\"")
  end

  test "does not wire the dismiss Stimulus controller when not dismissible" do
    actual = render_inline(AtomicView::Components::ChipComponent.new) { "Filter" }.to_html.strip

    assert_not_includes(actual, "data-controller")
  end

  test "merges dismiss_button_options onto the dismiss button" do
    actual = render_inline(
      AtomicView::Components::ChipComponent.new(
        dismissible: true,
        dismiss_button_options: {class: "custom-dismiss", data: {controller: "analytics", action: "click->analytics#track"}}
      )
    ) { "Filter" }.to_html.strip

    assert_includes(actual, "data-controller=\"analytics\"")
    assert_includes(actual, "data-action=\"click->analytics#track\"")
    assert_includes(actual, "custom-dismiss")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(class: "custom-chip", id: "site-chip")) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span id="site-chip" class="inline-flex items-center gap-1 rounded-btn bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border custom-chip">Filter</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders a link chip when href is given" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(href: "/rentals?status=active")) { "Active" }.to_html.strip

    assert_includes(actual, "<a")
    assert_includes(actual, 'href="/rentals?status=active"')
    assert_includes(actual, "rounded-btn")
  end

  test "marks a selected link chip with aria-current and active styling" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(href: "#", selected: true)) { "Active" }.to_html.strip

    assert_includes(actual, 'aria-current="true"')
    assert_includes(actual, "ring-current")
  end

  test "does not mark an unselected link chip as active" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(href: "#", selected: false)) { "Active" }.to_html.strip

    assert_not_includes(actual, "aria-current")
    assert_not_includes(actual, "ring-current")
  end

  test "a selected chip keeps a custom color class rather than overriding it" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(href: "#", selected: true, class: "text-success")) { "Active" }.to_html.strip

    assert_includes(actual, "text-success")
    assert_includes(actual, "ring-current")
  end

  test "renders a radio chip when name is given" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(name: "status", value: "active", selected: true)) { "Active" }.to_html.strip

    assert_includes(actual, 'type="radio"')
    assert_includes(actual, 'name="status"')
    assert_includes(actual, 'value="active"')
    assert_includes(actual, "checked")
    assert_includes(actual, "<label")
    assert_includes(actual, 'for="status_active"')
  end

  test "does not check an unselected radio chip" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(name: "status", value: "active", selected: false)) { "Active" }.to_html.strip

    assert_not_includes(actual, 'checked="checked"')
  end

  test "a radio chip keeps a custom color class alongside the peer-checked emphasis" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(name: "status", value: "active", selected: true, class: "text-success")) { "Active" }.to_html.strip

    assert_includes(actual, "text-success")
    assert_includes(actual, "peer-checked:ring-current")
  end

  test "wraps a radio chip's input/label pair in a display:contents span, isolating it from sibling chips" do
    # `peer-checked:` relies on the CSS general sibling combinator (`~`),
    # which matches every later sibling under the same parent -- rendered
    # as flat siblings (as multiple chips in one FiltersComponent with_chip
    # block are), checking one radio would otherwise light up every chip
    # after it. This wrapper scopes each pair's sibling relationship to
    # just the two of them.
    actual = render_inline(AtomicView::Components::ChipComponent.new(name: "status", value: "active", selected: true)) { "Active" }.to_html.strip

    assert_match(%r{\A<span class="contents"><input.*<label.*</label></span>\z}m, actual)
  end
end

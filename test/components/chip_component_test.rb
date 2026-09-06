# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ChipComponentTest < ViewComponent::TestCase
  test "renders a plain chip by default" do
    actual = render_inline(AtomicView::Components::ChipComponent.new) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center gap-1 rounded-pill bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border">Filter</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders leading content before the main content" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(leading: "<span class=\"dot\"></span>".html_safe)) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center gap-1 rounded-pill bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border"><span class="dot"></span>Filter</span>
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
    assert_includes(actual, "data-action=\"click-&gt;atomic-view--chip#remove\"")
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
    assert_includes(actual, "data-action=\"click-&gt;analytics#track\"")
    assert_includes(actual, "custom-dismiss")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::ChipComponent.new(class: "custom-chip", id: "site-chip")) { "Filter" }.to_html.strip
    expected = <<~HTML.strip
      <span id="site-chip" class="inline-flex items-center gap-1 rounded-pill bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border custom-chip">Filter</span>
    HTML

    assert_equal(expected, actual)
  end
end

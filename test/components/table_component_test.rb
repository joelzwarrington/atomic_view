# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TableComponentTest < ViewComponent::TestCase
  test "renders a table wrapper with the expected classes" do
    actual = render_inline(AtomicView::Components::TableComponent.new) { "Content" }.to_html.strip
    expected = <<~HTML.strip
      <table class="w-full text-sm">Content</table>
    HTML

    assert_equal(expected, actual)
  end

  test "yields the component instance so the block can build its own thead/tbody" do
    actual = render_inline(AtomicView::Components::TableComponent.new) do |table|
      "<thead><tr class=\"#{table.head_class}\"><th>Name</th></tr></thead>" \
        "<tbody><tr class=\"#{table.row_class}\"><td>Riverbend</td></tr></tbody>".html_safe
    end.to_html

    assert_includes(actual, "text-left text-xs font-semibold uppercase tracking-wide text-muted-foreground border-b border-border")
    assert_includes(actual, "border-b border-border hover:bg-offset")
    assert_includes(actual, "<th>Name</th>")
    assert_includes(actual, "<td>Riverbend</td>")
  end

  test "head_class exposes the header row styling" do
    component = AtomicView::Components::TableComponent.new
    render_inline(component) { "" }

    assert_equal(
      "text-left text-xs font-semibold uppercase tracking-wide text-muted-foreground border-b border-border",
      component.head_class
    )
  end

  test "row_class exposes the body row styling" do
    component = AtomicView::Components::TableComponent.new
    render_inline(component) { "" }

    assert_equal("border-b border-border hover:bg-offset", component.row_class)
  end

  test "head_class merges custom classes" do
    component = AtomicView::Components::TableComponent.new
    render_inline(component) { "" }

    assert_includes(component.head_class(class: "custom-head"), "custom-head")
  end

  test "row_class merges custom classes" do
    component = AtomicView::Components::TableComponent.new
    render_inline(component) { "" }

    assert_includes(component.row_class(class: "custom-row"), "custom-row")
  end

  test "merges custom class and forwards other options on the table tag" do
    actual = render_inline(AtomicView::Components::TableComponent.new(class: "custom-table", id: "parks-table")) { "Content" }.to_html.strip
    expected = <<~HTML.strip
      <table id="parks-table" class="w-full text-sm custom-table">Content</table>
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TableComponentTest < ViewComponent::TestCase
  test "renders a table wrapper with the expected classes" do
    actual = render_inline(AtomicView::Components::TableComponent.new) { "<tbody><tr><td>Content</td></tr></tbody>".html_safe }.to_html.strip
    expected = <<~HTML.strip
      <table class="w-full text-sm"><tbody><tr><td>Content</td></tr></tbody></table>
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
    actual = render_inline(AtomicView::Components::TableComponent.new(class: "custom-table", id: "parks-table")) { "<tbody><tr><td>Content</td></tr></tbody>".html_safe }.to_html.strip
    expected = <<~HTML.strip
      <table id="parks-table" class="w-full text-sm custom-table"><tbody><tr><td>Content</td></tr></tbody></table>
    HTML

    assert_equal(expected, actual)
  end

  test "renders no thead when no columns are given, same as before" do
    actual = render_inline(AtomicView::Components::TableComponent.new) { "<tbody><tr><td>Content</td></tr></tbody>".html_safe }.to_html

    assert_not_includes(actual, "<thead")
  end

  test "renders a thead built from with_column" do
    actual = render_inline(AtomicView::Components::TableComponent.new(model: Booking)) { |table|
      table.with_column(attribute: :camper_name)
      table.with_column(attribute: :status, align: :center)
      "".html_safe
    }.to_html

    assert_includes(actual, "<thead")
    assert_includes(actual, "<th scope=\"col\" class=\"p-2 font-medium\">Camper name</th>")
    assert_includes(actual, "<th scope=\"col\" class=\"p-2 font-medium text-center\">Status</th>")
  end

  test "passes the table's model through to with_column automatically" do
    component = AtomicView::Components::TableComponent.new(model: Booking)
    render_inline(component) { |table| table.with_column(attribute: :camper_name) }

    assert_equal(Booking, component.columns.first.model)
  end

  test "wraps rows in a tbody once columns are given, same as the raw block would have" do
    actual = render_inline(AtomicView::Components::TableComponent.new(model: Booking)) { |table|
      table.with_column(attribute: :camper_name)
      "<tr><td>Karen Wilson</td></tr>".html_safe
    }.to_html

    assert_includes(actual, "<tbody")
    assert_includes(actual, "<tr><td>Karen Wilson</td></tr>")
  end

  test "defaults the tbody id to the model's plural name" do
    actual = render_inline(AtomicView::Components::TableComponent.new(model: Booking)) { |table|
      table.with_column(attribute: :camper_name)
      "".html_safe
    }.to_html

    assert_includes(actual, '<tbody id="bookings">')
  end

  test "body_id overrides the default tbody id" do
    actual = render_inline(AtomicView::Components::TableComponent.new(model: Booking, body_id: "custom_body")) { |table|
      table.with_column(attribute: :camper_name)
      "".html_safe
    }.to_html

    assert_includes(actual, '<tbody id="custom_body">')
  end

  test "renders a bare tbody with no id when there is no model or body_id" do
    actual = render_inline(AtomicView::Components::TableComponent.new) { |table|
      table.with_column(label: "Name")
      "".html_safe
    }.to_html

    assert_includes(actual, "<tbody>")
  end
end

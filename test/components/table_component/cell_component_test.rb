# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TableComponent::CellComponentTest < ViewComponent::TestCase
  test "renders the cell content" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true)) { "Karen Wilson" }.to_html

    assert_includes(actual, "<td")
    assert_includes(actual, "Karen Wilson")
  end

  test "renders a stretched link to the path" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true)) { "Karen Wilson" }.to_html

    assert_includes(actual, "<a")
    assert_includes(actual, 'href="/bookings/1"')
    assert_includes(actual, "absolute inset-0")
  end

  test "puts the first cell's link in the tab order with an accessible label" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true)) { "Karen Wilson" }.to_html

    assert_includes(actual, 'tabindex="0"')
    assert_includes(actual, 'aria-label="Karen Wilson"')
    assert_not_includes(actual, "aria-hidden")
  end

  test "removes non-first cell links from the tab order and hides them from assistive tech" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: false)) { "Active" }.to_html

    assert_includes(actual, 'tabindex="-1"')
    assert_includes(actual, 'aria-hidden="true"')
    assert_not_includes(actual, "aria-label")
  end

  test "renders no link when clickable is false" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true, clickable: false)) { "Karen Wilson" }.to_html

    assert_not_includes(actual, "<a")
  end

  test "renders no link when path is blank" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: nil, label: "Karen Wilson", first: true)) { "Karen Wilson" }.to_html

    assert_not_includes(actual, "<a")
  end

  test "adds a centered, bold alignment variant" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true, align: :center)) { "Active" }.to_html

    assert_includes(actual, "text-center")
    assert_includes(actual, "font-semibold")
  end

  test "adds a right alignment class" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true, align: :right)) { "Active" }.to_html

    assert_includes(actual, "text-right")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::TableComponent::CellComponent.new(path: "/bookings/1", label: "Karen Wilson", first: true, class: "custom-cell", title: "Karen Wilson")) { "Karen Wilson" }.to_html

    assert_includes(actual, "custom-cell")
    assert_includes(actual, 'title="Karen Wilson"')
  end
end

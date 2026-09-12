# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::GanttComponent::RowComponentTest < ViewComponent::TestCase
  ORIGIN = Date.new(2026, 9, 1)

  test "renders the label and sublabel" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", sublabel: "Riverside", origin: ORIGIN)).to_html

    assert_includes(actual, "RS002")
    assert_includes(actual, "Riverside")
  end

  test "renders no sublabel by default" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN))

    assert_equal(0, actual.css(".text-xs.text-muted-foreground").size)
  end

  test "renders the label as plain text without href" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN)).to_html

    assert_not_includes(actual, "<a")
  end

  test "renders the label as a link when href is given" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN, href: "/sites/rs002")).to_html

    assert_includes(actual, "<a")
    assert_includes(actual, "href=\"/sites/rs002\"")
  end

  test "gives the track a predictable id for turbo_stream targeting" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN)).to_html

    assert_includes(actual, "id=\"row-1_track\"")
  end

  test "renders each with_item" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN)) { |row|
      row.with_item(starts_on: ORIGIN, ends_on: ORIGIN + 2, origin: ORIGIN, label: "Karen Wilson")
    }.to_html

    assert_includes(actual, "Karen Wilson")
  end

  test "renders no today strip by default" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN)).to_html

    assert_not_includes(actual, "bg-primary/5")
  end

  test "renders a today strip positioned from origin when today is given" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN, today: ORIGIN + 2, cell_width: 40)).to_html

    assert_includes(actual, "bg-primary/5")
    assert_includes(actual, "left: 80px")
  end

  test "sizes the track for a single lane by default" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN)).to_html

    expected_height = (AtomicView::Components::GanttComponent::LANE_TOP_PADDING * 2) + AtomicView::Components::GanttComponent::LANE_HEIGHT
    assert_includes(actual, "min-height: #{expected_height}px")
  end

  test "grows the track height with more lanes" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN, lanes: 3)).to_html

    expected_height = (AtomicView::Components::GanttComponent::LANE_TOP_PADDING * 2) + (3 * AtomicView::Components::GanttComponent::LANE_HEIGHT)
    assert_includes(actual, "min-height: #{expected_height}px")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::GanttComponent::RowComponent.new(id: "row-1", label: "RS002", origin: ORIGIN, class: "custom-row", title: "RS002")).to_html

    assert_includes(actual, "custom-row")
    assert_includes(actual, "title=\"RS002\"")
  end
end

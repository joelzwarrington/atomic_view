# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::GanttComponent::ItemComponentTest < ViewComponent::TestCase
  ORIGIN = Date.new(2026, 9, 1)

  test "renders as a div without href" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_includes(actual, "<div")
    assert_not_includes(actual, "<a")
  end

  test "renders as a link when href is given" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, href: "/rentals/1")).to_html

    assert_includes(actual, "<a")
    assert_includes(actual, "href=\"/rentals/1\"")
  end

  test "renders the label" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, label: "Karen Wilson")).to_html

    assert_includes(actual, "Karen Wilson")
  end

  test "renders block content instead of the label when given" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, label: "ignored")) {
      "<span class=\"custom-content\">Custom</span>".html_safe
    }.to_html

    assert_includes(actual, "custom-content")
    assert_not_includes(actual, "ignored")
  end

  test "positions the bar at pixel 0 when starts_on equals origin" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, cell_width: 40)).to_html

    assert_includes(actual, "left: 0px")
  end

  test "positions the bar with a pixel offset for each day after origin" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN + 3, ends_on: ORIGIN + 3, origin: ORIGIN, cell_width: 40)).to_html

    assert_includes(actual, "left: 120px")
  end

  test "positions the bar with a negative offset when starts_on is before origin" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN - 2, ends_on: ORIGIN, origin: ORIGIN, cell_width: 40)).to_html

    assert_includes(actual, "left: -80px")
  end

  test "sizes the bar to span an inclusive date range" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN + 4, origin: ORIGIN, cell_width: 40)).to_html

    assert_includes(actual, "width: 200px")
  end

  test "sizes a single-day bar to exactly one cell" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, cell_width: 40)).to_html

    assert_includes(actual, "width: 40px")
  end

  test "defaults to the primary variant" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_includes(actual, "bg-primary")
  end

  test "renders success variant classes" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, variant: :success)).to_html

    assert_includes(actual, "bg-success")
  end

  test "renders outline variant classes" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, variant: :outline)).to_html

    assert_includes(actual, "border-dashed")
    assert_includes(actual, "bg-transparent")
  end

  test "renders no hover/focus affordance classes without href" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_not_includes(actual, "cursor-pointer")
  end

  test "renders hover/focus affordance classes when href is given" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, href: "/rentals/1")).to_html

    assert_includes(actual, "cursor-pointer")
    assert_includes(actual, "focus-visible:ring-2")
  end

  test "positions the bar fractionally within a week column at the week scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN + 3, ends_on: ORIGIN + 3, origin: ORIGIN, cell_width: 70, scale: :week)).to_html

    assert_includes(actual, "left: 30px")
  end

  test "sizes a bar spanning exactly one month to one cell at the month scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: Date.new(2026, 9, 30), origin: ORIGIN, cell_width: 60, scale: :month)).to_html

    assert_includes(actual, "width: 60px")
  end

  test "renders no id by default" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_not_includes(actual, " id=")
  end

  test "renders a given id as a stable turbo_stream target" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(id: "booking_1_bar", starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_includes(actual, "id=\"booking_1_bar\"")
  end

  test "positions lane 0 at the top padding by default" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN)).to_html

    assert_includes(actual, "top: #{AtomicView::Components::GanttComponent::LANE_TOP_PADDING}px")
  end

  test "positions a later lane below earlier ones" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, lane: 1)).to_html

    expected_top = AtomicView::Components::GanttComponent::LANE_TOP_PADDING + AtomicView::Components::GanttComponent::LANE_HEIGHT
    assert_includes(actual, "top: #{expected_top}px")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: ORIGIN, ends_on: ORIGIN, origin: ORIGIN, class: "custom-bar", title: "Karen Wilson")).to_html

    assert_includes(actual, "custom-bar")
    assert_includes(actual, "title=\"Karen Wilson\"")
  end
end

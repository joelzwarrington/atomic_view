# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::GanttComponent::DateHeaderComponentTest < ViewComponent::TestCase
  test "renders the day number and weekday at the default (day) scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1))).to_html

    assert_includes(actual, ">1<")
    assert_includes(actual, ">Tue<")
  end

  test "renders month/day and 'Week' at the week scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), scale: :week)).to_html

    assert_includes(actual, ">Sep 1<")
    assert_includes(actual, ">Week<")
  end

  test "renders month name and year at the month scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), scale: :month)).to_html

    assert_includes(actual, ">Sep 1<")
    assert_includes(actual, ">2026<")
  end

  test "highlights when today falls on this exact date at the day scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 9), today: Date.new(2026, 9, 9))).to_html

    assert_includes(actual, "text-primary")
  end

  test "does not highlight a different date at the day scale" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), today: Date.new(2026, 9, 9))).to_html

    assert_not_includes(actual, "text-primary")
  end

  test "highlights the whole week today falls within at the week scale" do
    week_start = Date.new(2026, 9, 7) # a Monday
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: week_start, scale: :week, today: Date.new(2026, 9, 9))).to_html

    assert_includes(actual, "text-primary")
  end

  test "does not highlight without a today" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 9))).to_html

    assert_not_includes(actual, "text-primary")
  end

  test "sets the cell width" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), cell_width: 60)).to_html

    assert_includes(actual, "width: 60px")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), class: "custom-header", title: "Sept 1")).to_html

    assert_includes(actual, "custom-header")
    assert_includes(actual, "title=\"Sept 1\"")
  end
end

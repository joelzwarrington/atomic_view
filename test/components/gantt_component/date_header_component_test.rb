# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::GanttComponent::DateHeaderComponentTest < ViewComponent::TestCase
  test "renders the day number and weekday" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1))).to_html

    assert_includes(actual, ">1<")
    assert_includes(actual, ">Tue<")
  end

  test "highlights when today falls on this exact date" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 9), today: Date.new(2026, 9, 9))).to_html

    assert_includes(actual, "text-primary")
  end

  test "does not highlight a different date" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), today: Date.new(2026, 9, 9))).to_html

    assert_not_includes(actual, "text-primary")
  end

  test "does not highlight without a today" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 9))).to_html

    assert_not_includes(actual, "text-primary")
  end

  test "renders no width style of its own -- the parent grid sizes it" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1))).to_html

    assert_not_includes(actual, "style=")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: Date.new(2026, 9, 1), class: "custom-header", title: "Sept 1")).to_html

    assert_includes(actual, "custom-header")
    assert_includes(actual, "title=\"Sept 1\"")
  end
end

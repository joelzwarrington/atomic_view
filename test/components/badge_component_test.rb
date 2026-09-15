# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::BadgeComponentTest < ViewComponent::TestCase
  test "renders default variant by default" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new) { "Active" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-transparent bg-primary text-primary-foreground">Active</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders secondary variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :secondary)) { "Draft" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-transparent bg-secondary text-secondary-foreground">Draft</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders destructive variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :destructive)) { "Cancelled" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-destructive bg-destructive/10 text-destructive">Cancelled</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders success variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :success)) { "Active" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-success bg-success/10 text-success">Active</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders warning variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :warning)) { "Upcoming" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-warning bg-warning/10 text-warning">Upcoming</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders info variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :info)) { "Draft" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-info bg-info/10 text-info">Draft</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders outline variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :outline)) { "Completed" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-border bg-transparent text-foreground">Completed</span>
    HTML

    assert_equal(expected, actual)
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(class: "custom-badge", id: "status-badge")) { "Active" }.to_html.strip
    expected = <<~HTML.strip
      <span id="status-badge" class="inline-flex items-center rounded-btn border px-1.5 py-0.5 text-xs font-medium border-transparent bg-primary text-primary-foreground custom-badge">Active</span>
    HTML

    assert_equal(expected, actual)
  end
end

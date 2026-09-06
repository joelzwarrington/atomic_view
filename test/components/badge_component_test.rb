# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::BadgeComponentTest < ViewComponent::TestCase
  test "renders default variant by default" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new) { "Active" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium bg-primary text-primary-foreground">Active</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders secondary variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :secondary)) { "Draft" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium bg-secondary text-secondary-foreground">Draft</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders destructive variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :destructive)) { "Needs attention" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium bg-destructive text-destructive-foreground">Needs attention</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders outline variant" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(variant: :outline)) { "Pending" }.to_html.strip
    expected = <<~HTML.strip
      <span class="inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium bg-transparent border border-border text-foreground">Pending</span>
    HTML

    assert_equal(expected, actual)
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::BadgeComponent.new(class: "custom-badge", id: "status-badge")) { "Active" }.to_html.strip
    expected = <<~HTML.strip
      <span id="status-badge" class="inline-flex items-center rounded-pill px-1.5 py-0.5 text-xs font-medium bg-primary text-primary-foreground custom-badge">Active</span>
    HTML

    assert_equal(expected, actual)
  end
end

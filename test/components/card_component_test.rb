# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CardComponentTest < ViewComponent::TestCase
  test "renders a plain card by default" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { "Content" }.to_html.strip
    expected = <<~HTML.strip
      <div class="bg-surface rounded-card border border-border p-3">Content</div>
    HTML

    assert_equal(expected, actual)
  end

  test "adds hover shadow classes when hoverable" do
    actual = render_inline(AtomicView::Components::CardComponent.new(hoverable: true)) { "Content" }.to_html.strip
    expected = <<~HTML.strip
      <div class="bg-surface rounded-card border border-border p-3 hover:shadow-soft transition-shadow">Content</div>
    HTML

    assert_equal(expected, actual)
  end

  test "does not add hover shadow classes by default" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { "Content" }.to_html.strip

    assert_not_includes(actual, "hover:shadow-soft")
    assert_not_includes(actual, "transition-shadow")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::CardComponent.new(class: "custom-card", id: "profile-card")) { "Content" }.to_html.strip
    expected = <<~HTML.strip
      <div id="profile-card" class="bg-surface rounded-card border border-border p-3 custom-card">Content</div>
    HTML

    assert_equal(expected, actual)
  end
end

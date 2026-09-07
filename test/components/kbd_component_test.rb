# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::KbdComponentTest < ViewComponent::TestCase
  test "renders a single keycap" do
    actual = render_inline(AtomicView::Components::KbdComponent.new) { "Esc" }.to_html.strip
    expected = <<~HTML.strip
      <kbd class="inline-flex h-5 min-w-5 items-center justify-center rounded-well border border-border bg-offset px-1 font-mono text-xs text-muted-foreground">Esc</kbd>
    HTML

    assert_equal(expected, actual)
  end

  test "renders arbitrary content, including a symbol" do
    actual = render_inline(AtomicView::Components::KbdComponent.new) { "⌘" }.to_html.strip

    assert_includes(actual, "⌘")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::KbdComponent.new(class: "custom-kbd", id: "close-hint")) { "Esc" }.to_html.strip

    assert_includes(actual, "custom-kbd")
    assert_includes(actual, 'id="close-hint"')
  end
end

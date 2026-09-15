# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CardComponentTest < ViewComponent::TestCase
  test "renders a plain card by default" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { "Content" }.to_html

    assert_includes(actual, "bg-surface rounded-card border border-border")
    assert_includes(actual, "p-2.5 px-4")
    assert_includes(actual, "Content")
  end

  test "renders the destructive variant with a tinted red border and background" do
    actual = render_inline(AtomicView::Components::CardComponent.new(variant: :destructive)) { "Danger zone" }.to_html

    assert_includes(actual, "border-destructive bg-destructive/10")
    assert_not_includes(actual, "border-border")
    assert_includes(actual, "Danger zone")
  end

  test "adds hover shadow classes when hoverable" do
    actual = render_inline(AtomicView::Components::CardComponent.new(hoverable: true)) { "Content" }.to_html

    assert_includes(actual, "hover:shadow-soft")
    assert_includes(actual, "transition-shadow")
  end

  test "does not add hover shadow classes by default" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { "Content" }.to_html

    assert_not_includes(actual, "hover:shadow-soft")
    assert_not_includes(actual, "transition-shadow")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::CardComponent.new(class: "custom-card", id: "profile-card")) { "Content" }.to_html

    assert_includes(actual, "custom-card")
    assert_includes(actual, "id=\"profile-card\"")
  end

  test "renders plain content when no sections are given" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { "Plain content" }.to_html

    assert_includes(actual, "Plain content")
    assert_not_includes(actual, "divide-y")
  end

  test "wraps sections in a divide-y container instead of rendering default content" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { |card|
      card.with_section { "First row" }
      card.with_section { "Second row" }
    }.to_html

    assert_includes(actual, "divide-y divide-border")
    assert_includes(actual, "First row")
    assert_includes(actual, "Second row")
  end

  test "uses a destructive-tinted divider color when the card variant is destructive" do
    actual = render_inline(AtomicView::Components::CardComponent.new(variant: :destructive)) { |card|
      card.with_section { "First row" }
      card.with_section { "Second row" }
    }.to_html

    assert_includes(actual, "divide-y divide-destructive/30")
    assert_not_includes(actual, "divide-border")
  end

  test "does not apply the card's own padding to the outer wrapper when sectioned" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { |card|
      card.with_section { "First row" }
    }.to_html

    assert_includes(actual, "class=\"bg-surface rounded-card border border-border\"")
  end

  test "each section gets its own padding" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { |card|
      card.with_section { "First row" }
    }.to_html

    assert_includes(actual, "class=\"p-2.5 px-4\"")
  end

  test "merges a section's custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::CardComponent.new) { |card|
      card.with_section(class: "custom-section", id: "row-1") { "First row" }
    }.to_html

    assert_includes(actual, "custom-section")
    assert_includes(actual, "id=\"row-1\"")
  end
end

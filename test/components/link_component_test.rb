# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::LinkComponentTest < ViewComponent::TestCase
  test "renders an anchor with the href and primary variant by default" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new")) { "New park" }

    link = actual.css("a").first
    assert_equal("/parks/new", link["href"])
    assert_equal("New park", link.text.strip)
    assert_includes(link["class"], "bg-primary")
    assert_includes(link["class"], "text-primary-foreground")
  end

  test "renders block content" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new")) { "Custom Content".html_safe }

    assert_equal("Custom Content", actual.css("a").first.text.strip)
  end

  test "merges a custom class and forwards other html options" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new", class: "custom-link", id: "new-park", data: {turbo_frame: "_top"})) { "New park" }

    link = actual.css("a").first
    assert_includes(link["class"], "custom-link")
    assert_equal("new-park", link["id"])
    assert_equal("_top", link["data-turbo-frame"])
  end

  test "does not render a kbd when no keybinds are given" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new")) { "New park" }.to_html

    assert_not_includes(actual, "<kbd")
  end

  test "renders a single keybind as a kbd" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new", keybinds: "N")) { "New park" }.to_html

    assert_includes(actual, "<kbd")
    assert_includes(actual, ">N</kbd>")
  end

  test "renders a chord of keybinds as multiple kbds" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/search", keybinds: ["⌘", "K"])) { "Search" }

    kbds = actual.css("kbd")
    assert_equal(2, kbds.size)
    assert_equal("⌘", kbds[0].text.strip)
    assert_equal("K", kbds[1].text.strip)
  end

  test "does not wire the hotkey controller when no keybinds are given" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new")) { "New park" }

    link = actual.css("a").first
    assert_nil(link["data-controller"])
    assert_nil(link["data-action"])
  end

  test "wires the hotkey controller and a lowercased keydown filter for a single keybind" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new", keybinds: "N")) { "New park" }

    link = actual.css("a").first
    assert_equal("atomic-view--hotkey", link["data-controller"])
    assert_equal("keydown.n@window->atomic-view--hotkey#click", link["data-action"])
  end

  test "normalizes modifier symbols to Stimulus modifier names for a chord" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/search", keybinds: ["⌘", "K"])) { "Search" }

    link = actual.css("a").first
    assert_equal("keydown.meta+k@window->atomic-view--hotkey#click", link["data-action"])
  end

  test "merges the hotkey controller/action alongside existing data attributes" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("/parks/new", keybinds: "N", data: {controller: "custom", action: "click->custom#go", turbo_frame: "_top"})) { "New park" }

    link = actual.css("a").first
    assert_equal("custom atomic-view--hotkey", link["data-controller"])
    assert_equal("click->custom#go keydown.n@window->atomic-view--hotkey#click", link["data-action"])
    assert_equal("_top", link["data-turbo-frame"])
  end

  # Variant tests
  test "renders secondary variant" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("#", variant: :secondary)) { "Secondary" }

    assert_includes(actual.css("a").first["class"], "bg-secondary")
  end

  test "renders destructive variant" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("#", variant: :destructive)) { "Delete" }

    assert_includes(actual.css("a").first["class"], "bg-destructive")
  end

  test "renders muted variant" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("#", variant: :muted)) { "Edit" }

    assert_includes(actual.css("a").first["class"], "text-muted-foreground")
  end

  test "renders link variant" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("#", variant: :link)) { "Learn more" }

    assert_includes(actual.css("a").first["class"], "underline-offset-4")
  end

  test "renders outline variant" do
    actual = render_inline(AtomicView::Components::LinkComponent.new("#", variant: :outline)) { "View details" }

    assert_includes(actual.css("a").first["class"], "border-border")
  end
end

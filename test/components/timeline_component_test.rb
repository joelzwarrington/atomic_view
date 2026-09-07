# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TimelineComponentTest < ViewComponent::TestCase
  test "renders a meta line with the actor bolded and the description after it" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "flag", actor: "Karen Will", description: "created this park", time: "Jan 12, 2024"}]
    )).to_html

    assert_includes(actual, "<strong class=\"font-semibold\">Karen Will</strong>")
    assert_includes(actual, "created this park")
  end

  test "renders the description without a bolded actor when actor is omitted" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "arrow-path", description: "Status changed automatically", time: "3 days ago"}]
    )).to_html

    assert_not_includes(actual, "<strong")
    assert_includes(actual, "Status changed automatically")
  end

  test "renders the time when given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "flag", description: "created this park", time: "Jan 12, 2024"}]
    )).to_html

    assert_includes(actual, "Jan 12, 2024")
  end

  test "renders an icon marker in a circular badge" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "flag", description: "created this park"}]
    )).to_html

    assert_includes(actual, "rounded-full")
    assert_includes(actual, "<svg")
  end

  test "renders an avatar marker via AvatarComponent when avatar is given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{avatar: "KW", actor: "Karen Will", description: "commented"}]
    )).to_html

    assert_includes(actual, "KW")
    assert_includes(actual, "rounded-full")
  end

  test "renders free-form content below the meta line when given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "arrow-path", description: "changed the tax code", content: "<span class=\"diff-chip\">HST NS 2025</span>".html_safe}]
    )).to_html

    assert_includes(actual, "diff-chip")
    assert_includes(actual, "HST NS 2025")
  end

  test "renders a connecting line between items but not after the last one" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [
        {icon: "flag", description: "First"},
        {icon: "flag", description: "Second"}
      ]
    )).to_html

    assert_equal(1, actual.scan("bg-border").size)
  end

  test "does not render a connecting line for a single item" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "flag", description: "Only item"}]
    )).to_html

    assert_not_includes(actual, "bg-border")
  end

  test "merges custom class and forwards other options onto the container" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(
      items: [{icon: "flag", description: "created this park"}],
      class: "custom-timeline",
      id: "park-activity"
    )).to_html

    assert_includes(actual, "custom-timeline")
    assert_includes(actual, "id=\"park-activity\"")
  end
end

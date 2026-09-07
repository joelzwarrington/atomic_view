# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TimelineComponentTest < ViewComponent::TestCase
  test "renders a meta line with the actor bolded and the description after it" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", actor: "Karen Will", description: "created this park", time: Time.utc(2024, 1, 12))
    }.to_html

    assert_includes(actual, "<strong class=\"font-semibold\">Karen Will</strong>")
    assert_includes(actual, "created this park")
  end

  test "renders the description without a bolded actor when actor is omitted" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "arrow-path", description: "Status changed automatically", time: 3.days.ago)
    }.to_html

    assert_not_includes(actual, "<strong")
    assert_includes(actual, "Status changed automatically")
  end

  test "renders the time as a local-time element when given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", description: "created this park", time: Time.utc(2024, 1, 12, 10, 0))
    }.to_html

    assert_includes(actual, "data-local=\"time-ago\"")
    assert_includes(actual, "datetime=\"2024-01-12T10:00:00Z\"")
  end

  test "renders no time element when time is omitted" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", description: "created this park")
    }.to_html

    assert_not_includes(actual, "data-local")
  end

  test "renders an icon marker in a circular badge" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", description: "created this park")
    }.to_html

    assert_includes(actual, "rounded-full")
    assert_includes(actual, "<svg")
  end

  test "renders an avatar marker via AvatarComponent when avatar is given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(avatar: "KW", actor: "Karen Will", description: "commented")
    }.to_html

    assert_includes(actual, "KW")
    assert_includes(actual, "rounded-full")
  end

  test "renders free-form block content below the meta line when given" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "arrow-path", description: "changed the tax code") do
        "<span class=\"diff-chip\">HST NS 2025</span>".html_safe
      end
    }.to_html

    assert_includes(actual, "diff-chip")
    assert_includes(actual, "HST NS 2025")
  end

  test "renders a connecting line between items but not after the last one" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", description: "First")
      timeline.with_item(icon: "flag", description: "Second")
    }.to_html

    assert_equal(1, actual.scan("bg-border").size)
  end

  test "does not render a connecting line for a single item" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new) { |timeline|
      timeline.with_item(icon: "flag", description: "Only item")
    }.to_html

    assert_not_includes(actual, "bg-border")
  end

  test "merges custom class and forwards other options onto the container" do
    actual = render_inline(AtomicView::Components::TimelineComponent.new(class: "custom-timeline", id: "park-activity")) { |timeline|
      timeline.with_item(icon: "flag", description: "created this park")
    }.to_html

    assert_includes(actual, "custom-timeline")
    assert_includes(actual, "id=\"park-activity\"")
  end
end

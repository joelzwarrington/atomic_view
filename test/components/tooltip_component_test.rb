# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TooltipComponentTest < ViewComponent::TestCase
  test "renders the trigger slot" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new) do |tooltip|
      tooltip.with_trigger { "Save" }
    end.to_html

    assert_includes(actual, "Save")
  end

  test "renders text as the tooltip content" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(text: "Save changes")) do |tooltip|
      tooltip.with_trigger { "Save" }
    end.to_html

    assert_includes(actual, "Save changes")
  end

  test "renders the body slot instead of text when given" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(text: "Save changes")) do |tooltip|
      tooltip.with_trigger { "Save" }
      tooltip.with_body { "Richer content" }
    end.to_html

    assert_includes(actual, "Richer content")
    assert_not_includes(actual, "Save changes")
  end

  test "renders the tooltip content hidden by default" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(text: "Save changes")) do |tooltip|
      tooltip.with_trigger { "Save" }
    end.to_html

    assert_match(/role="tooltip" class="[^"]*\bhidden\b[^"]*"/, actual)
  end

  test "always renders the tooltip controller" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new).to_html

    assert_includes(actual, "data-controller=\"atomic-view--tooltip\"")
  end

  test "defaults the placement value to top" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new).to_html

    assert_includes(actual, "data-atomic-view--tooltip-placement-value=\"top\"")
  end

  test "accepts a supported placement" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(placement: "bottom")).to_html

    assert_includes(actual, "data-atomic-view--tooltip-placement-value=\"bottom\"")
  end

  test "falls back to top for an unsupported placement" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(placement: "diagonal")).to_html

    assert_includes(actual, "data-atomic-view--tooltip-placement-value=\"top\"")
  end

  test "wires the trigger target and hover/focus actions" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new) do |tooltip|
      tooltip.with_trigger { "Save" }
    end.to_html

    assert_includes(actual, "data-atomic-view--tooltip-target=\"trigger\"")
    assert_includes(actual, "mouseenter->atomic-view--tooltip#show")
    assert_includes(actual, "mouseleave->atomic-view--tooltip#hide")
    assert_includes(actual, "focusin->atomic-view--tooltip#show")
    assert_includes(actual, "focusout->atomic-view--tooltip#hide")
  end

  test "wires the content target" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new).to_html

    assert_includes(actual, "data-atomic-view--tooltip-target=\"content\"")
  end

  test "associates the trigger with the tooltip content via aria-describedby" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new) do |tooltip|
      tooltip.with_trigger { "Save" }
    end.to_html

    content_id = actual[/id="(tooltip-[^"]+)"/, 1]
    refute_nil(content_id)
    assert_includes(actual, "aria-describedby=\"#{content_id}\"")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::TooltipComponent.new(class: "custom-tooltip", data: {testid: "tooltip"})
    ).to_html

    assert_includes(actual, "custom-tooltip")
    assert_includes(actual, "data-testid=\"tooltip\"")
  end

  test "does not forward text as an html attribute on the root" do
    actual = render_inline(AtomicView::Components::TooltipComponent.new(text: "Save changes")).to_html

    assert_not_includes(actual, "text=\"Save changes\"")
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TabsComponentTest < ViewComponent::TestCase
  test "renders an anchor for each option with its href" do
    actual = render_inline(
      AtomicView::Components::TabsComponent.new(
        options: [
          {label: "Overview", href: "/parks/1"},
          {label: "Invoices", href: "/parks/1/invoices"}
        ],
        selected: "Overview"
      )
    )

    overview_link = actual.css("a").find { |node| node.text == "Overview" }
    invoices_link = actual.css("a").find { |node| node.text == "Invoices" }

    assert_equal("/parks/1", overview_link["href"])
    assert_equal("/parks/1/invoices", invoices_link["href"])
  end

  test "styles the option matching selected as active" do
    actual = render_inline(
      AtomicView::Components::TabsComponent.new(
        options: [
          {label: "Overview", href: "/parks/1"},
          {label: "Activity", href: "/parks/1/activity"}
        ],
        selected: "Activity"
      )
    )

    overview_link = actual.css("a").find { |node| node.text == "Overview" }
    activity_link = actual.css("a").find { |node| node.text == "Activity" }

    assert_includes(activity_link["class"], "border-accent")
    assert_includes(activity_link["class"], "text-accent")
    assert_equal("true", activity_link["aria-current"])

    assert_includes(overview_link["class"], "border-transparent")
    assert_includes(overview_link["class"], "text-muted-foreground")
    assert_nil(overview_link["aria-current"])
  end

  test "wraps tabs in a container with a bottom divider" do
    actual = render_inline(
      AtomicView::Components::TabsComponent.new(
        options: [{label: "Overview", href: "/parks/1"}],
        selected: "Overview"
      )
    )

    container = actual.css("div").first
    assert_includes(container["class"], "flex")
    assert_includes(container["class"], "border-b")
    assert_includes(container["class"], "border-border")
  end

  test "merges a custom class and forwards other options onto the container" do
    actual = render_inline(
      AtomicView::Components::TabsComponent.new(
        options: [{label: "Overview", href: "/parks/1"}],
        selected: "Overview",
        class: "custom-tabs",
        id: "park-tabs"
      )
    )

    container = actual.css("div").first
    assert_includes(container["class"], "custom-tabs")
    assert_equal("park-tabs", container["id"])
  end
end

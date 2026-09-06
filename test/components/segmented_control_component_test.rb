# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::SegmentedControlComponentTest < ViewComponent::TestCase
  test "link mode renders an anchor for each option with its href" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "All", href: "/parks"},
          {label: "Active", href: "/parks?filter=active"}
        ],
        selected: "All"
      )
    )

    all_link = actual.css("a").find { |node| node.text == "All" }
    active_link = actual.css("a").find { |node| node.text == "Active" }

    assert_equal("/parks", all_link["href"])
    assert_equal("/parks?filter=active", active_link["href"])
  end

  test "link mode styles the option matching selected as active" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "All", href: "/parks"},
          {label: "Active", href: "/parks?filter=active"}
        ],
        selected: "Active"
      )
    )

    all_link = actual.css("a").find { |node| node.text == "All" }
    active_link = actual.css("a").find { |node| node.text == "Active" }

    assert_includes(active_link["class"], "bg-surface")
    assert_includes(active_link["class"], "text-foreground")
    assert_includes(active_link["class"], "shadow-sm")
    assert_equal("true", active_link["aria-current"])

    assert_includes(all_link["class"], "text-muted-foreground")
    assert_not_includes(all_link["class"], "bg-surface")
    assert_nil(all_link["aria-current"])
  end

  test "link mode wraps tabs in a pill track" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [{label: "All", href: "/parks"}],
        selected: "All"
      )
    )

    track = actual.css("div").first
    assert_includes(track["class"], "inline-flex")
    assert_includes(track["class"], "rounded-btn")
    assert_includes(track["class"], "bg-offset")
  end

  test "radio mode renders a radio input per option with name and value" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "Monthly", value: "monthly"},
          {label: "Seasonal", value: "seasonal"}
        ],
        selected: "monthly",
        name: "billing_cycle"
      )
    )

    monthly_input = actual.css("input[type='radio']").find { |node| node["value"] == "monthly" }
    seasonal_input = actual.css("input[type='radio']").find { |node| node["value"] == "seasonal" }

    assert_equal("billing_cycle", monthly_input["name"])
    assert_equal("billing_cycle", seasonal_input["name"])
    assert_includes(monthly_input["class"], "peer")
    assert_includes(monthly_input["class"], "sr-only")
  end

  test "radio mode checks the option matching selected" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "Monthly", value: "monthly"},
          {label: "Seasonal", value: "seasonal"}
        ],
        selected: "seasonal",
        name: "billing_cycle"
      )
    )

    monthly_input = actual.css("input[type='radio']").find { |node| node["value"] == "monthly" }
    seasonal_input = actual.css("input[type='radio']").find { |node| node["value"] == "seasonal" }

    assert_nil(monthly_input["checked"])
    assert_equal("checked", seasonal_input["checked"])
  end

  test "radio mode renders a label per option wired to its input via for/id and peer-checked classes" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [
          {label: "Monthly", value: "monthly"},
          {label: "Seasonal", value: "seasonal"}
        ],
        selected: "monthly",
        name: "billing_cycle"
      )
    )

    seasonal_input = actual.css("input[type='radio']").find { |node| node["value"] == "seasonal" }
    seasonal_label = actual.css("label").find { |node| node.text == "Seasonal" }

    assert_equal(seasonal_input["id"], seasonal_label["for"])
    assert_includes(seasonal_label["class"], "peer-checked:bg-surface")
    assert_includes(seasonal_label["class"], "peer-checked:text-foreground")
    assert_includes(seasonal_label["class"], "peer-checked:shadow-sm")
  end

  test "merges a custom class and forwards other options onto the track container" do
    actual = render_inline(
      AtomicView::Components::SegmentedControlComponent.new(
        options: [{label: "All", href: "/parks"}],
        selected: "All",
        class: "custom-segmented-control",
        id: "filter-tabs"
      )
    )

    track = actual.css("div").first
    assert_includes(track["class"], "custom-segmented-control")
    assert_equal("filter-tabs", track["id"])
  end
end

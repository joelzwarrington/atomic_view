# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CommandPaletteComponent::RowComponentTest < ViewComponent::TestCase
  test "renders standalone as a link, outside of the dialog" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard"))

    row = actual.css("a").first
    assert_equal("/dashboard", row["href"])
    assert_equal("Dashboard", row.text.strip)
    assert_equal("row", row["data-atomic-view--command-palette-target"])
  end

  test "defaults the href to # when none is given" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard"))

    assert_equal("#", actual.css("a").first["href"])
  end

  test "gives the row a lowercased data-search-text attribute" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard"))

    assert_equal("dashboard", actual.css("a").first["data-search-text"])
  end

  test "allows a result to override its matchable search text" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard", search_text: "dashboard home overview")
    )

    assert_equal("dashboard home overview", actual.css("a").first["data-search-text"])
  end

  test "renders a keyboard-hint kbd when a hint is given" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard", hint: "G D")
    ).to_html

    assert_includes(actual, "<kbd")
    assert_includes(actual, "G D")
    assert_includes(actual, "rounded-well")
    assert_includes(actual, "font-mono")
  end

  test "does not render a kbd when no hint is given" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard")).to_html

    assert_not_includes(actual, "<kbd")
  end

  test "renders an icon before the label when given" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard", icon: "home")
    ).to_html

    assert_includes(actual, "<svg")
  end

  test "does not render an icon when none is given" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard")).to_html

    assert_not_includes(actual, "<svg")
  end

  test "merges extra data options without overriding the target and search-text hooks" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::RowComponent.new(label: "Dashboard", href: "/dashboard", data: {testid: "row"})
    )

    row = actual.css("a").first
    assert_equal("row", row["data-testid"])
    assert_equal("row", row["data-atomic-view--command-palette-target"])
    assert_equal("dashboard", row["data-search-text"])
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CommandPaletteComponent::SectionComponentTest < ViewComponent::TestCase
  test "renders standalone as a labeled group, outside of the dialog" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::SectionComponent.new(
        label: "Pages",
        results: [{label: "Dashboard", href: "/dashboard"}]
      )
    ).to_html

    assert_includes(actual, "role=\"group\"")
    assert_includes(actual, "Pages")
    assert_includes(actual, "text-xs font-semibold uppercase text-muted-foreground")
  end

  test "renders a row per result, via the results: sugar" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent::SectionComponent.new(
        label: "Pages",
        results: [
          {label: "Dashboard", href: "/dashboard"},
          {label: "Settings", href: "/settings"}
        ]
      )
    )

    hrefs = actual.css("a").map { |row| row["href"] }
    assert_equal(["/dashboard", "/settings"], hrefs)
  end

  test "renders a row per with_row, via the slot API" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::SectionComponent.new(label: "Pages")) do |section|
      section.with_row(label: "Dashboard", href: "/dashboard")
    end

    row = actual.css("a").first
    assert_equal("/dashboard", row["href"])
    assert_equal("Dashboard", row.text.strip)
  end

  test "renders no rows by default" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent::SectionComponent.new(label: "Pages")).to_html

    assert_not_includes(actual, "<a")
  end
end

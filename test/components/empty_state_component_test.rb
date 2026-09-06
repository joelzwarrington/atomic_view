# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::EmptyStateComponentTest < ViewComponent::TestCase
  test "renders an icon and title by default" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages")).to_html

    assert_includes(actual, "<svg")
    assert_includes(actual, "No messages")
  end

  test "does not render a description by default" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages")).to_html

    assert_not_includes(actual, "text-muted-foreground text-sm")
  end

  test "renders a description when given" do
    actual = render_inline(
      AtomicView::Components::EmptyStateComponent.new(
        icon_name: "map",
        title: "No parks found",
        description: "Try adjusting your filters or search terms."
      )
    ).to_html

    assert_includes(actual, "Try adjusting your filters or search terms.")
    assert_includes(actual, "text-muted-foreground text-sm")
  end

  test "renders block content as an action area" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "users", title: "No campers yet")) do
      "<a href=\"#\">Add camper</a>".html_safe
    end.to_html

    assert_includes(actual, "<a href=\"#\">Add camper</a>")
  end

  test "does not render extra content when no block is given" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages")).to_html.strip

    assert_not_includes(actual, "<a href")
  end

  test "renders the icon with the expected classes" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages")).to_html

    assert_includes(actual, "size-10 text-muted-foreground")
  end

  test "renders the outer container with the expected layout classes" do
    actual = render_inline(AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages")).to_html

    assert_includes(actual, "flex flex-col items-center text-center gap-2 p-8")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::EmptyStateComponent.new(icon_name: "inbox", title: "No messages", class: "custom-empty-state", id: "inbox-empty-state")
    ).to_html

    assert_includes(actual, "custom-empty-state")
    assert_includes(actual, "id=\"inbox-empty-state\"")
  end
end

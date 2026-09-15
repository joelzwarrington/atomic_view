# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DrawerComponentTest < ViewComponent::TestCase
  test "renders the dialog with the given id" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_includes(actual, "<dialog")
    assert_includes(actual, "id=\"example-drawer\"")
  end

  test "renders the title when given" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer", title: "Add a product")).to_html

    assert_includes(actual, "Add a product")
  end

  test "does not render a heading when no title is given" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_not_includes(actual, "<h2")
  end

  test "renders the body content" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")) do
      "Name of the product or service, visible to customers."
    end.to_html

    assert_includes(actual, "Name of the product or service, visible to customers.")
  end

  test "always renders a close button" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_includes(actual, "atomic-view--drawer#close")
    assert_includes(actual, "aria-label=\"Close\"")
  end

  test "does not render actions by default" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_not_includes(actual, "Show preview")
  end

  test "renders the actions slot when given" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")) do |drawer|
      drawer.with_actions { "Show preview" }
      "Body"
    end.to_html

    assert_includes(actual, "Show preview")
  end

  test "does not render a footer by default" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_not_includes(actual, "border-t border-border")
  end

  test "renders footer buttons when the footer slot is given" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")) do |drawer|
      drawer.with_footer do
        '<button type="button">Cancel</button><button type="button">Add product</button>'.html_safe
      end
    end.to_html

    assert_includes(actual, "border-t border-border")
    assert_includes(actual, "Cancel")
    assert_includes(actual, "Add product")
  end

  test "always renders the drawer controller" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_includes(actual, "data-controller=\"atomic-view--drawer\"")
  end

  test "does not set the open value by default" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_not_includes(actual, "drawer-open-value")
  end

  test "sets the open value when open is true" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer", open: true)).to_html

    assert_includes(actual, "data-atomic-view--drawer-open-value=\"true\"")
  end

  test "pins to the right edge by default" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer")).to_html

    assert_includes(actual, "right-0")
    assert_includes(actual, "left-auto")
  end

  test "pins to the left edge when side is :left" do
    actual = render_inline(AtomicView::Components::DrawerComponent.new(id: "example-drawer", side: :left)).to_html

    assert_includes(actual, "left-0")
    assert_includes(actual, "right-auto")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::DrawerComponent.new(id: "example-drawer", class: "custom-drawer", data: {testid: "drawer"})
    ).to_html

    assert_includes(actual, "custom-drawer")
    assert_includes(actual, "data-testid=\"drawer\"")
  end
end

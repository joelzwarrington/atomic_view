# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::NavItemComponentTest < ViewComponent::TestCase
  test "renders an inactive nav item by default" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home")).to_html.strip
    expected = <<~HTML.strip
      <a href="/home" class="flex items-center gap-2 rounded-btn px-2.5 py-1.5 text-sm font-medium text-muted-foreground hover:bg-offset hover:text-foreground">
        Home
      </a>
    HTML

    assert_equal(expected, actual)
  end

  test "renders active state classes" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home", active: true)).to_html

    assert_includes(actual, "bg-secondary")
    assert_includes(actual, "text-secondary-foreground")
    assert_not_includes(actual, "text-muted-foreground")
    assert_not_includes(actual, "hover:bg-offset")
  end

  test "renders inactive state classes" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home")).to_html

    assert_includes(actual, "text-muted-foreground")
    assert_includes(actual, "hover:bg-offset")
    assert_includes(actual, "hover:text-foreground")
    assert_not_includes(actual, "bg-secondary")
  end

  test "renders the href" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Parks", href: "/parks")).to_html

    assert_includes(actual, "href=\"/parks\"")
  end

  test "renders the label text" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Campers", href: "/campers")).to_html

    assert_includes(actual, "Campers")
  end

  test "renders an icon before the label when given" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home", icon: "home")).to_html

    assert_includes(actual, "<svg")
    assert_includes(actual, "size-4 shrink-0")
  end

  test "does not render an icon by default" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home")).to_html

    assert_not_includes(actual, "<svg")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::NavItemComponent.new(label: "Home", href: "/home", class: "custom-nav-item", title: "Home")).to_html

    assert_includes(actual, "custom-nav-item")
    assert_includes(actual, "title=\"Home\"")
  end
end

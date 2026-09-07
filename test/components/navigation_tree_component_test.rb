# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::NavigationTreeComponentTest < ViewComponent::TestCase
  test "renders a label heading when given" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new(label: "Products")) { |tree|
      tree.with_item(label: "Home", href: "/home")
    }.to_html

    assert_includes(actual, "Products")
  end

  test "does not render a label heading by default" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home")
    }.to_html

    assert_not_includes(actual, "<div")
  end

  test "renders a leaf item as a link" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Parks", href: "/parks")
    }.to_html

    assert_includes(actual, "<a")
    assert_includes(actual, "href=\"/parks\"")
    assert_includes(actual, "Parks")
  end

  test "renders active state classes on a leaf item" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home", active: true)
    }.to_html

    assert_includes(actual, "bg-secondary")
    assert_includes(actual, "text-secondary-foreground")
    assert_not_includes(actual, "text-muted-foreground")
  end

  test "renders inactive state classes on a leaf item by default" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home")
    }.to_html

    assert_includes(actual, "text-muted-foreground")
    assert_includes(actual, "hover:bg-offset")
    assert_not_includes(actual, "bg-secondary")
  end

  test "renders an icon before the label when given" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home", icon: "home")
    }.to_html

    assert_includes(actual, "<svg")
    assert_includes(actual, "size-4 shrink-0")
  end

  test "does not render an icon by default" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home")
    }.to_html

    assert_not_includes(actual, "<svg")
  end

  test "merges custom class and forwards other options on a leaf item" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Home", href: "/home", class: "custom-nav-item", title: "Home")
    }.to_html

    assert_includes(actual, "custom-nav-item")
    assert_includes(actual, "title=\"Home\"")
  end

  test "renders an item without an href as a details/summary disclosure" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Sites", icon: "building-office-2") do |sites|
        sites.with_item(label: "Overview", href: "/sites")
      end
    }.to_html

    assert_includes(actual, "<details")
    assert_includes(actual, "<summary")
    assert_includes(actual, "Sites")
  end

  test "renders nested items inside the disclosure" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Sites") do |sites|
        sites.with_item(label: "Overview", href: "/sites")
        sites.with_item(label: "Availability", href: "/sites/availability")
      end
    }.to_html

    assert_includes(actual, "href=\"/sites\"")
    assert_includes(actual, "href=\"/sites/availability\"")
  end

  test "opens the disclosure by default when the group itself is active" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Sites", active: true) do |sites|
        sites.with_item(label: "Overview", href: "/sites")
      end
    }.to_html

    assert_includes(actual, "<details open")
  end

  test "opens the disclosure by default when a nested item is active" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Sites") do |sites|
        sites.with_item(label: "Overview", href: "/sites", active: true)
      end
    }.to_html

    assert_includes(actual, "<details open")
  end

  test "does not open the disclosure by default when nothing inside it is active" do
    actual = render_inline(AtomicView::Components::NavigationTreeComponent.new) { |tree|
      tree.with_item(label: "Sites") do |sites|
        sites.with_item(label: "Overview", href: "/sites")
      end
    }.to_html

    assert_not_includes(actual, "<details open")
  end
end

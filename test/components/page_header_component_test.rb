# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::PageHeaderComponentTest < ViewComponent::TestCase
  test "renders the title" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_title { "Rentals" }
    }.to_html

    assert_includes(actual, "<h1")
    assert_includes(actual, "Rentals")
  end

  test "does not render a breadcrumb line when the slot is not given" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_title { "Rentals" }
    }.to_html

    assert_not_includes(actual, "text-primary")
  end

  test "renders the breadcrumbs slot above the title" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_breadcrumbs { "Rentals" }
      header.with_title { "RS002 · Karen Wilson" }
    }.to_html

    assert_match(/Rentals.*RS002/m, actual)
  end

  test "renders the badge slot inline with the title" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_title { "RS002 · Karen Wilson" }
      header.with_badge { "<span class=\"status-badge\">Active</span>".html_safe }
    }.to_html

    assert_includes(actual, "status-badge")
  end

  test "renders the subtitle slot below the title" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_title { "Rentals" }
      header.with_subtitle { "62 rentals across 3 parks" }
    }.to_html

    assert_includes(actual, "62 rentals across 3 parks")
  end

  test "renders the actions slot" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new) { |header|
      header.with_title { "Rentals" }
      header.with_actions { "<a href=\"#\">New rental</a>".html_safe }
    }.to_html

    assert_includes(actual, "New rental")
  end

  test "merges custom class and forwards other options onto the container" do
    actual = render_inline(AtomicView::Components::PageHeaderComponent.new(class: "custom-header", id: "page-header")) { |header|
      header.with_title { "Rentals" }
    }.to_html

    assert_includes(actual, "custom-header")
    assert_includes(actual, "id=\"page-header\"")
  end
end

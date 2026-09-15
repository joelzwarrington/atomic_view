# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::IndexPageComponentTest < ViewComponent::TestCase
  test "renders the title via the internal page header" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      "Body content"
    }.to_html

    assert_includes(actual, "<h1")
    assert_includes(actual, "Rentals")
  end

  test "renders the breadcrumbs, badge, subtitle, and actions slots via the internal page header" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      page.with_breadcrumbs { "Home" }
      page.with_badge { "<span class=\"count-badge\">62</span>".html_safe }
      page.with_subtitle { "62 rentals across 3 parks" }
      page.with_actions { "<a href=\"#\">New rental</a>".html_safe }
      "Body content"
    }.to_html

    assert_includes(actual, "Home")
    assert_includes(actual, "count-badge")
    assert_includes(actual, "62 rentals across 3 parks")
    assert_includes(actual, "New rental")
  end

  test "renders the filters slot" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      page.with_filters { "<div class=\"status-pills\">All</div>".html_safe }
      "Body content"
    }.to_html

    assert_includes(actual, "status-pills")
  end

  test "renders the toolbar slot" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      page.with_toolbar { "<div class=\"search-row\">Search</div>".html_safe }
      "Body content"
    }.to_html

    assert_includes(actual, "search-row")
  end

  test "renders default block content when not empty" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      "<table class=\"rentals-table\"></table>".html_safe
    }.to_html

    assert_includes(actual, "rentals-table")
  end

  test "renders the empty state instead of the default content block when empty" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new(empty: true)) { |page|
      page.with_title { "Rentals" }
      page.with_empty_state { "<p class=\"empty-state\">No rentals yet</p>".html_safe }
      "<table class=\"rentals-table\"></table>".html_safe
    }.to_html

    assert_includes(actual, "empty-state")
    assert_not_includes(actual, "rentals-table")
  end

  test "renders the pagination slot only when not empty" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new) { |page|
      page.with_title { "Rentals" }
      page.with_pagination { "<nav class=\"pager\"></nav>".html_safe }
      "Body content"
    }.to_html

    assert_includes(actual, "pager")
  end

  test "does not render pagination when empty" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new(empty: true)) { |page|
      page.with_title { "Rentals" }
      page.with_pagination { "<nav class=\"pager\"></nav>".html_safe }
    }.to_html

    assert_not_includes(actual, "pager")
  end

  test "sets the container id from dom_id" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new(dom_id: :rentals)) { |page|
      page.with_title { "Rentals" }
    }.to_html

    assert_includes(actual, "id=\"rentals\"")
  end

  test "an explicit id option takes precedence over dom_id" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new(dom_id: :rentals, id: "custom-id")) { |page|
      page.with_title { "Rentals" }
    }.to_html

    assert_includes(actual, "id=\"custom-id\"")
    assert_not_includes(actual, "id=\"rentals\"")
  end

  test "merges custom class and forwards other options onto the container" do
    actual = render_inline(AtomicView::Components::IndexPageComponent.new(class: "custom-index-page")) { |page|
      page.with_title { "Rentals" }
    }.to_html

    assert_includes(actual, "custom-index-page")
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ShowPageComponentTest < ViewComponent::TestCase
  test "renders the title via the internal page header" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
    }.to_html

    assert_includes(actual, "<h1")
    assert_includes(actual, "RS002 · Karen Wilson")
  end

  test "renders the breadcrumbs, badge, subtitle, and actions slots via the internal page header" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
      page.with_breadcrumbs { "Rentals" }
      page.with_badge { "<span class=\"status-badge\">Active</span>".html_safe }
      page.with_subtitle { "rental_9f21ba7c" }
      page.with_actions { "<a href=\"#\">Edit</a>".html_safe }
    }.to_html

    assert_includes(actual, "Rentals")
    assert_includes(actual, "status-badge")
    assert_includes(actual, "rental_9f21ba7c")
    assert_includes(actual, "Edit")
  end

  test "renders the highlight slot as a full-width region above the body" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
      page.with_highlight { "<div class=\"stepper\">stepper content</div>".html_safe }
    }.to_html

    assert_includes(actual, "stepper content")
  end

  test "does not render a highlight wrapper when the slot is not given" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
    }.to_html

    assert_not_includes(actual, "stepper")
  end

  test "renders default block content as the main column" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
      "<section>Overview</section>".html_safe
    }.to_html

    assert_includes(actual, "Overview")
  end

  test "renders the sidebar slot as a second column" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
      page.with_sidebar { "<div class=\"details-panel\">Details</div>".html_safe }
      "Main content"
    }.to_html

    assert_includes(actual, "details-panel")
    assert_includes(actual, "sm:grid-cols-3")
  end

  test "does not add the two-column grid classes when there is no sidebar" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new) { |page|
      page.with_title { "RS002 · Karen Wilson" }
      "Main content"
    }.to_html

    assert_not_includes(actual, "sm:grid-cols-3")
  end

  test "merges custom class and forwards other options onto the container" do
    actual = render_inline(AtomicView::Components::ShowPageComponent.new(class: "custom-show-page", id: "rental-show")) { |page|
      page.with_title { "RS002 · Karen Wilson" }
    }.to_html

    assert_includes(actual, "custom-show-page")
    assert_includes(actual, "id=\"rental-show\"")
  end
end

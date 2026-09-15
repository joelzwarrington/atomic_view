# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::FiltersComponentTest < ViewComponent::TestCase
  test "renders a form pointed at the given url and method" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals", method: :get)).to_html

    assert_includes(actual, "<form")
    assert_includes(actual, 'action="/rentals"')
  end

  test "wires the auto-submit controller and a bubbled action on the form itself" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals")).to_html

    assert_includes(actual, 'data-controller="atomic-view--auto-submit"')
    assert_includes(actual, "input->atomic-view--auto-submit#submit")
    assert_includes(actual, "change->atomic-view--auto-submit#submit")
  end

  test "renders a hidden field per preserve entry" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals", preserve: {view: "timeline"})).to_html

    assert_includes(actual, 'type="hidden"')
    assert_includes(actual, 'name="view"')
    assert_includes(actual, 'value="timeline"')
  end

  test "with_search yields a form-like object that renders real fields" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals")) { |filters|
      filters.with_search { |form| form.search_field(:q, value: "Karen") }
    }.to_html

    assert_includes(actual, 'type="search"')
    assert_includes(actual, 'value="Karen"')
  end

  test "with_filter can be given multiple times and each renders" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals")) { |filters|
      filters.with_filter { |form| form.select(:park_id, [["Riverbend", 1]]) }
      filters.with_filter { |form| form.select(:rental_type, [["Monthly", "monthly"]]) }
    }.to_html

    assert_includes(actual, "Riverbend")
    assert_includes(actual, "Monthly")
  end

  test "with_chip renders each group in its own row" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals")) { |filters|
      filters.with_chip { "<span>status chips</span>".html_safe }
      filters.with_chip { "<span>type chips</span>".html_safe }
    }.to_html

    assert_includes(actual, "status chips")
    assert_includes(actual, "type chips")
  end

  test "renders no search/filter row when neither is given" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals")) { |filters|
      filters.with_chip { "status" }
    }.to_html

    assert_not_includes(actual, "sm:flex-row")
  end

  test "merges custom class onto the form" do
    actual = render_inline(AtomicView::Components::FiltersComponent.new(url: "/rentals", class: "custom-filters")).to_html

    assert_includes(actual, "custom-filters")
  end
end

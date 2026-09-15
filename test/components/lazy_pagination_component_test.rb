# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::LazyPaginationComponentTest < ViewComponent::TestCase
  test "renders a lazily-loaded turbo-frame when a next page is present" do
    actual = render_inline(AtomicView::Components::LazyPaginationComponent.new(next_page: 2, next_page_path: "/bookings?page=2")).to_html

    assert_includes(actual, "<turbo-frame")
    assert_includes(actual, 'id="pagination"')
    assert_includes(actual, 'loading="lazy"')
    assert_includes(actual, 'src="/bookings?page=2"')
  end

  test "renders a spinner and loading text when a next page is present" do
    actual = render_inline(AtomicView::Components::LazyPaginationComponent.new(next_page: 2, next_page_path: "/bookings?page=2")).to_html

    assert_includes(actual, "animate-spin")
    assert_includes(actual, "sr-only")
  end

  test "renders an empty turbo-frame with no src when there is no next page" do
    actual = render_inline(AtomicView::Components::LazyPaginationComponent.new(next_page: nil)).to_html.strip

    assert_equal('<turbo-frame id="pagination"></turbo-frame>', actual)
  end

  test "uses a custom id for the turbo-frame" do
    actual = render_inline(AtomicView::Components::LazyPaginationComponent.new(next_page: 2, next_page_path: "/bookings?page=2", id: :bookings_pagination)).to_html

    assert_includes(actual, 'id="bookings_pagination"')
  end

  test "next_page? is true when next_page is present" do
    component = AtomicView::Components::LazyPaginationComponent.new(next_page: 2)

    assert(component.next_page?)
  end

  test "next_page? is false when next_page is nil" do
    component = AtomicView::Components::LazyPaginationComponent.new(next_page: nil)

    assert_not(component.next_page?)
  end
end

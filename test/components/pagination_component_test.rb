# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::PaginationComponentTest < ViewComponent::TestCase
  test "renders a link for each page number" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 2, total_pages: 4, path_for_page: ->(page) { "/parks?page=#{page}" })
    )

    (1..4).each do |page|
      link = actual.css("a").find { |node| node.text == page.to_s }
      assert(link, "expected a link for page #{page}")
      assert_equal("/parks?page=#{page}", link["href"])
    end
  end

  test "styles the current page as active and others as inactive" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 2, total_pages: 3, path_for_page: ->(page) { "/parks?page=#{page}" })
    )

    page_one = actual.css("a").find { |node| node.text == "1" }
    page_two = actual.css("a").find { |node| node.text == "2" }

    assert_includes(page_one["class"], "text-muted-foreground")
    assert_includes(page_one["class"], "hover:bg-offset")
    assert_not_includes(page_one["class"], "bg-secondary")

    assert_includes(page_two["class"], "bg-secondary")
    assert_includes(page_two["class"], "text-secondary-foreground")
    assert_equal("page", page_two["aria-current"])
  end

  test "links previous and next to the adjacent page via path_for_page" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 2, total_pages: 3, path_for_page: ->(page) { "/parks?page=#{page}" })
    )

    previous_link = actual.css("a").find { |node| node.text == "Previous" }
    next_link = actual.css("a").find { |node| node.text == "Next" }

    assert_equal("/parks?page=1", previous_link["href"])
    assert_equal("/parks?page=3", next_link["href"])
  end

  test "renders previous as a disabled, non-linking span on the first page" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 1, total_pages: 3, path_for_page: ->(page) { "/parks?page=#{page}" })
    )

    refute_includes(actual.to_html, "Previous</a>")

    previous_span = actual.css("span").find { |node| node.text == "Previous" }
    assert_includes(previous_span["class"], "opacity-50")
    assert_includes(previous_span["class"], "pointer-events-none")
    assert_equal("true", previous_span["aria-disabled"])
  end

  test "renders next as a disabled, non-linking span on the last page" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 3, total_pages: 3, path_for_page: ->(page) { "/parks?page=#{page}" })
    )

    refute_includes(actual.to_html, "Next</a>")

    next_span = actual.css("span").find { |node| node.text == "Next" }
    assert_includes(next_span["class"], "opacity-50")
    assert_includes(next_span["class"], "pointer-events-none")
    assert_equal("true", next_span["aria-disabled"])
  end

  test "renders both previous and next as disabled spans when there is only one page" do
    actual = render_inline(
      AtomicView::Components::PaginationComponent.new(current_page: 1, total_pages: 1, path_for_page: ->(page) { "/parks?page=#{page}" })
    ).to_html

    refute_includes(actual, "Previous</a>")
    refute_includes(actual, "Next</a>")
  end
end

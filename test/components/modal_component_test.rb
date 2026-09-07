# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ModalComponentTest < ViewComponent::TestCase
  test "renders the dialog with the given id" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal")).to_html

    assert_includes(actual, "<dialog")
    assert_includes(actual, "id=\"example-modal\"")
  end

  test "renders the title when given" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal", title: "Update your plan")).to_html

    assert_includes(actual, "Update your plan")
  end

  test "does not render a heading when no title is given" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal")).to_html

    assert_not_includes(actual, "<h2")
  end

  test "does not render a danger icon by default" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal", title: "Delete project?")).to_html

    assert_not_includes(actual, "<svg")
  end

  test "renders a danger icon when danger is true" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "delete-modal", title: "Delete project?", danger: true)).to_html

    assert_includes(actual, "<svg")
    assert_includes(actual, "text-error")
  end

  test "renders the body content" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal")) do
      "This action cannot be undone."
    end.to_html

    assert_includes(actual, "This action cannot be undone.")
  end

  test "does not render a footer by default" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal")).to_html

    assert_not_includes(actual, "mt-4 flex justify-end gap-2")
  end

  test "renders footer buttons when the footer slot is given" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "delete-modal", title: "Delete project?", danger: true)) do |modal|
      modal.with_footer do
        '<button type="button">Cancel</button><button type="button">Delete</button>'.html_safe
      end
    end.to_html

    assert_includes(actual, "mt-4 flex justify-end gap-2")
    assert_includes(actual, "Cancel")
    assert_includes(actual, "Delete")
  end

  test "always renders the modal controller" do
    actual = render_inline(AtomicView::Components::ModalComponent.new(id: "example-modal")).to_html

    assert_includes(actual, "data-controller=\"atomic-view--modal\"")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::ModalComponent.new(id: "example-modal", class: "custom-modal", data: {testid: "modal"})
    ).to_html

    assert_includes(actual, "custom-modal")
    assert_includes(actual, "data-testid=\"modal\"")
  end
end

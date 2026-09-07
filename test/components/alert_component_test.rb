# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::AlertComponentTest < ViewComponent::TestCase
  test "renders the info variant by default" do
    actual = render_inline(AtomicView::Components::AlertComponent.new) { "Heads up" }.to_html

    assert_includes(actual, "border-info")
    assert_includes(actual, "text-info")
    assert_not_includes(actual, "border-warning")
    assert_not_includes(actual, "border-success")
    assert_not_includes(actual, "border-destructive")
  end

  test "renders the success variant's icon and border color" do
    actual = render_inline(AtomicView::Components::AlertComponent.new(variant: :success)) { "Saved" }.to_html

    assert_includes(actual, "border-success")
    assert_includes(actual, "text-success")
    assert_includes(actual, "<svg")
  end

  test "renders the warning variant's icon and border color" do
    actual = render_inline(AtomicView::Components::AlertComponent.new(variant: :warning)) { "Careful" }.to_html

    assert_includes(actual, "border-warning")
    assert_includes(actual, "text-warning")
    assert_includes(actual, "<svg")
  end

  test "renders the error variant's icon and border color" do
    actual = render_inline(AtomicView::Components::AlertComponent.new(variant: :error)) { "Broken" }.to_html

    assert_includes(actual, "border-destructive")
    assert_includes(actual, "text-destructive")
    assert_includes(actual, "<svg")
  end

  test "does not render a title by default" do
    actual = render_inline(AtomicView::Components::AlertComponent.new) { "You have no credits left." }.to_html

    assert_not_includes(actual, "font-medium")
  end

  test "renders a title when given" do
    actual = render_inline(AtomicView::Components::AlertComponent.new(title: "No credits left")) { "Upgrade to continue." }.to_html

    assert_includes(actual, "No credits left")
    assert_includes(actual, "Upgrade to continue.")
  end

  test "renders arbitrary content, including links" do
    actual = render_inline(AtomicView::Components::AlertComponent.new(variant: :warning)) do
      '<a href="/billing">Upgrade your account</a>'.html_safe
    end.to_html

    assert_includes(actual, %(<a href="/billing">Upgrade your account</a>))
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::AlertComponent.new(class: "custom-alert", id: "credits-alert")
    ) { "Content" }.to_html

    assert_includes(actual, "custom-alert")
    assert_includes(actual, 'id="credits-alert"')
  end
end

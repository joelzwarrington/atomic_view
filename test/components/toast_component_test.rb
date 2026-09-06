# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ToastComponentTest < ViewComponent::TestCase
  test "renders the info variant by default" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Heads up")).to_html

    assert_includes(actual, "border-l-primary")
    assert_includes(actual, "text-primary")
    assert_not_includes(actual, "border-l-success")
    assert_not_includes(actual, "border-l-destructive")
  end

  test "renders the success variant's icon and border color" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(variant: :success, title: "Saved")).to_html

    assert_includes(actual, "border-l-success")
    assert_includes(actual, "text-success")
    assert_includes(actual, "<svg")
  end

  test "renders the error variant's icon and border color" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(variant: :error, title: "Something broke")).to_html

    assert_includes(actual, "border-l-destructive")
    assert_includes(actual, "text-destructive")
    assert_includes(actual, "<svg")
  end

  test "renders the title" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated")).to_html

    assert_includes(actual, "Profile updated")
  end

  test "does not render a description by default" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated")).to_html

    assert_not_includes(actual, "mt-1 text-sm text-muted-foreground")
  end

  test "renders a description when given" do
    actual = render_inline(
      AtomicView::Components::ToastComponent.new(title: "Profile updated", description: "Your changes have been saved.")
    ).to_html

    assert_includes(actual, "Your changes have been saved.")
  end

  test "renders a dismiss button by default" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated")).to_html

    assert_includes(actual, "<button type=\"button\"")
    assert_includes(actual, "atomic-view--toast#dismiss")
  end

  test "does not render a dismiss button when not dismissible" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated", dismissible: false)).to_html

    assert_not_includes(actual, "<button")
  end

  test "always renders the toast controller" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated")).to_html

    assert_includes(actual, "data-controller=\"atomic-view--toast\"")
  end

  test "does not render an auto-dismiss data attribute by default" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated")).to_html

    assert_not_includes(actual, "auto-dismiss-ms-value")
  end

  test "renders an auto-dismiss data attribute when auto_dismiss_ms is given" do
    actual = render_inline(AtomicView::Components::ToastComponent.new(title: "Profile updated", auto_dismiss_ms: 4000)).to_html

    assert_includes(actual, "data-atomic-view--toast-auto-dismiss-ms-value=\"4000\"")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::ToastComponent.new(title: "Profile updated", class: "custom-toast", id: "profile-toast")
    ).to_html

    assert_includes(actual, "custom-toast")
    assert_includes(actual, "id=\"profile-toast\"")
  end
end

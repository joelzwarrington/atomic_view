# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ThemeToggleComponentTest < ViewComponent::TestCase
  test "renders a button wired to the theme toggle controller" do
    actual = render_inline(AtomicView::Components::ThemeToggleComponent.new).to_html

    assert_includes(actual, "<button")
    assert_includes(actual, "type=\"button\"")
    assert_includes(actual, "data-controller=\"atomic-view--theme-toggle\"")
    assert_includes(actual, "data-action=\"click-&gt;atomic-view--theme-toggle#toggle\"")
  end

  test "has an accessible label" do
    actual = render_inline(AtomicView::Components::ThemeToggleComponent.new).to_html

    assert_includes(actual, "aria-label=\"Toggle theme\"")
  end

  test "renders both a sun and a moon icon" do
    actual = render_inline(AtomicView::Components::ThemeToggleComponent.new).to_html

    assert_equal(2, actual.scan("<svg").size)
  end

  test "crossfades sun and moon purely via dark: utility classes" do
    actual = render_inline(AtomicView::Components::ThemeToggleComponent.new).to_html

    assert_includes(actual, "opacity-100 transition-all duration-300 dark:rotate-90 dark:scale-50 dark:opacity-0")
    assert_includes(actual, "opacity-0 transition-all duration-300 dark:rotate-0 dark:scale-100 dark:opacity-100")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::ThemeToggleComponent.new(class: "custom-toggle", id: "site-theme-toggle")).to_html

    assert_includes(actual, "custom-toggle")
    assert_includes(actual, "id=\"site-theme-toggle\"")
  end
end

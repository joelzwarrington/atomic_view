# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DropdownComponentTest < ViewComponent::TestCase
  test "renders the trigger slot" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_trigger { "Open menu" }
    end.to_html

    assert_includes(actual, "Open menu")
  end

  test "renders the menu slot" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_menu { "Menu content" }
    end.to_html

    assert_includes(actual, "Menu content")
  end

  test "does not render a menu wrapper when the menu slot is not given" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_trigger { "Open menu" }
    end.to_html

    assert_not_includes(actual, "atomic-view--dropdown-target=\"menu\"")
  end

  test "always renders the dropdown controller" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new).to_html

    assert_includes(actual, "data-controller=\"atomic-view--dropdown\"")
  end

  test "wires the trigger target and toggle action" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_trigger { "Open menu" }
    end.to_html

    assert_includes(actual, "data-atomic-view--dropdown-target=\"trigger\"")
    assert_includes(actual, "data-action=\"click-&gt;atomic-view--dropdown#toggle\"")
  end

  test "wires the menu target" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_menu { "Menu content" }
    end.to_html

    assert_includes(actual, "data-atomic-view--dropdown-target=\"menu\"")
  end

  test "renders the menu hidden by default" do
    actual = render_inline(AtomicView::Components::DropdownComponent.new) do |dropdown|
      dropdown.with_menu { "Menu content" }
    end.to_html

    assert_match(/class="[^"]*\bhidden\b[^"]*"[^>]*data-atomic-view--dropdown-target="menu"/, actual)
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::DropdownComponent.new(class: "custom-dropdown", data: {testid: "dropdown"})
    ).to_html

    assert_includes(actual, "custom-dropdown")
    assert_includes(actual, "data-testid=\"dropdown\"")
  end
end

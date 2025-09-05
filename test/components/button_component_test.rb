# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ButtonComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(name: "Test User")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders button with string label and primary variant by default" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90">Submit</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with custom options and merges classes" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      class: "custom-button",
      id: "submit-btn",
      disabled: true
    })).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90 custom-button" id="submit-btn" disabled>Submit</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with block content" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {})) do
      "Custom Button Content"
    end.to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90">Custom Button Content</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with only options and block content" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, nil, {class: "btn-block"})) do
      "Block Content Only"
    end.to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90 btn-block">Block Content Only</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with data attributes" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      data: {confirm: "Are you sure?", method: :delete}
    })).to_html.strip
    expected = <<~HTML.strip
      <button data-confirm="Are you sure?" data-method="delete" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90">Submit</button>
    HTML

    assert_equal(expected, actual)
  end

  # Variant tests
  test "renders primary variant" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Primary", {variant: :primary})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90">Primary</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders secondary variant" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Secondary", {variant: :secondary})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80">Secondary</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders destructive variant" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Delete", {variant: :destructive})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-[3px] bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20">Delete</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders muted variant" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Muted", {variant: :muted})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-transparent text-muted-foreground hover:bg-muted">Muted</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders link variant" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Link", {variant: :link})).to_html.strip
    expected = <<~HTML.strip
      <button class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] text-primary underline-offset-4 hover:underline">Link</button>
    HTML

    assert_equal(expected, actual)
  end
end

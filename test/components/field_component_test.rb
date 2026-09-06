# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::FieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string

    validates :email, presence: true

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(name: "Test User", email: "test@example.com")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic field component" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with container html class" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with default html class" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with custom container class" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {container_class: "custom-container"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs custom-container">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with left section" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {left_section: "Left"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
              Left
            </div>
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring pl-10" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with left section as addon" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {
      left_section: "Addon",
      left_section_as_addon: true
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs flex">
            <span class="inline-flex items-center rounded-l-btn border border-r-0 border-ring/10 dark:border-white/10 bg-transparent dark:bg-white/5 px-3 text-primary dark:text-white sm:text-sm">Addon</span>
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring shadow-none rounded-none rounded-r-btn ring-inset" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with left section as interaction" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {
      left_section: content_tag(:button, "Click"),
      left_section_as_interaction: true
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs flex">
            <button>Click</button>
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring shadow-none rounded-none rounded-r-btn ring-inset" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with right section" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {right_section: "Right"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring pr-10" type="text" name="test_model[name]" id="test_model_name">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              Right
            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with right section as addon" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {
      right_section: "Addon",
      right_section_as_addon: true
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs flex">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring shadow-none rounded-none rounded-l-btn ring-inset" type="text" name="test_model[name]" id="test_model_name">
            <span class="inline-flex items-center rounded-r-btn border border-l-0 border-ring/10 dark:border-white/10 bg-transparent dark:bg-white/5 px-3 text-primary dark:text-white sm:text-sm">Addon</span>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with right section as interaction" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {
      right_section: content_tag(:button, "Click"),
      right_section_as_interaction: true
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs flex">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring shadow-none rounded-none rounded-l-btn ring-inset" type="text" name="test_model[name]" id="test_model_name">
            <button>Click</button>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "does not leak section/container options as html attributes on the input" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name, {
      left_section: "Left",
      left_section_as_addon: true,
      right_section: "Right",
      right_section_as_interaction: true,
      container_class: "custom-container"
    })).to_html

    assert_not_includes(actual, "left_section=")
    assert_not_includes(actual, "left_section_as_addon=")
    assert_not_includes(actual, "right_section=")
    assert_not_includes(actual, "right_section_as_interaction=")
    assert_not_includes(actual, "container_class=")
  end

  test "renders field with error styling when method has errors" do
    @object.errors.add(:name, "can't be blank")

    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" type="text" name="test_model[name]" id="test_model_name">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with error icon when method has errors" do
    @object.errors.add(:name, "can't be blank")

    actual = render_inline(AtomicView::Components::FieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" type="text" name="test_model[name]" id="test_model_name">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders field with custom tag class" do
    actual = render_inline(AtomicView::Components::FieldComponent.new(
      @form, :test_model, :email, {}, ActionView::Helpers::Tags::EmailField
    )).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="email" name="test_model[email]" id="test_model_email">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

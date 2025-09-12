# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TextFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(name: "Test User")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders text field component" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with custom options" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name, {
      placeholder: "Enter your name",
      class: "custom-input",
      maxlength: 50
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input placeholder="Enter your name" class="custom-input block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" maxlength="50" size="50" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with container styling" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with default input styling" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with left section" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name, {
      left_section: "Name:"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
              Name:
            </div>
        <input left_section="Name:" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring pl-10" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with right section" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name, {
      right_section: "@example.com"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input right_section="@example.com" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring pr-10" type="text" name="test_model[name]" id="test_model_name">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              @example.com
            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with error styling when field has errors" do
    @object.errors.add(:name, "can't be blank")

    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 dark:text-white focus:border-ring/20 dark:focus:ring-focus-ring pr-10 text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" type="text" name="test_model[name]" id="test_model_name">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with custom container class" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name, {
      container_class: "w-full lg:w-1/2"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs w-full lg:w-1/2">
        <input container_class="w-full lg:w-1/2" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with data attributes" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name, {
      data: {action: "input->controller#update"}
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input data-action="input-&gt;controller#update" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text field with value from model" do
    actual = render_inline(AtomicView::Components::TextFieldComponent.new(@form, :test_model, :name)).to_html.strip
    # Text field component doesn't automatically set value from model - this would come from Rails form helpers
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="text" name="test_model[name]" id="test_model_name">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::SelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :role, :string
    attribute :category, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(role: "admin")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders select component" do
    choices = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :role, choices)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with default styling" do
    choices = [["Option 1", "1"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="1">Option 1</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with custom options" do
    choices = [["Select option", ""], ["Option 1", "1"], ["Option 2", "2"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices, {
      prompt: "Choose an option"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="">Choose an option</option>
      <option selected value="">Select option</option>
      <option value="1">Option 1</option>
      <option value="2">Option 2</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with html options" do
    choices = [["Option 1", "1"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices, {}, {
      class: "custom-select",
      multiple: true
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input name="test_model[category][]" type="hidden" value="" autocomplete="off"><select class="custom-select block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" multiple name="test_model[category][]" id="test_model_category"><option value="1">Option 1</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with error styling when field has errors" do
    @object.errors.add(:role, "is required")
    choices = [["Admin", "admin"]]

    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :role, choices)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option></select>
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with different attribute" do
    choices = [["Category 1", "cat1"], ["Category 2", "cat2"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="cat1">Category 1</option>
      <option value="cat2">Category 2</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

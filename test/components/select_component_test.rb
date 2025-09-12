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
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with default styling" do
    choices = [["Option 1", "1"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="1">Option 1</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with custom options" do
    choices = [["Select option", ""], ["Option 1", "1"], ["Option 2", "2"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices, {
      prompt: "Choose an option"
    })).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="">Choose an option</option>
      <option selected value="">Select option</option>
      <option value="1">Option 1</option>
      <option value="2">Option 2</option></select>
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
      <input name="test_model[category][]" type="hidden" value="" autocomplete="off"><select class="custom-select block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" multiple name="test_model[category][]" id="test_model_category"><option value="1">Option 1</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with error styling when field has errors" do
    @object.errors.add(:role, "is required")
    choices = [["Admin", "admin"]]

    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :role, choices)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 dark:text-white focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders select with different attribute" do
    choices = [["Category 1", "cat1"], ["Category 2", "cat2"]]
    actual = render_inline(AtomicView::Components::SelectComponent.new(@form, :test_model, :category, choices)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="cat1">Category 1</option>
      <option value="cat2">Category 2</option></select>
    HTML

    assert_equal(expected, actual)
  end
end

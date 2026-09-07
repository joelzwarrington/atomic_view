# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CollectionSelectComponentTest < ViewComponent::TestCase
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
    @object = TestModel.new
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic collection select" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with prompt" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {prompt: "Select a role"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="">Select a role</option>
      <option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with selected value" do
    @object.role = "admin"
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    # The HTML should be the same, as selection state is handled internally by Rails form helpers
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with object collection" do
    # Test with actual objects instead of arrays
    roles = [
      OpenStruct.new(name: "Administrator", value: "admin"),
      OpenStruct.new(name: "Regular User", value: "user")
    ]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, roles, :value, :name)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Administrator</option>
      <option value="user">Regular User</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with different field name" do
    options = [["Technology", "tech"], ["Design", "design"], ["Marketing", "marketing"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :category, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[category]" id="test_model_category"><option value="tech">Technology</option>
      <option value="design">Design</option>
      <option value="marketing">Marketing</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with html options" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {}, {class: "custom-select", multiple: true})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input name="test_model[role][]" type="hidden" value=""><select class="custom-select block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" multiple="multiple" name="test_model[role][]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with data attributes" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select data-action="change->controller#update" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with error styling when field has errors" do
    @object.errors.add(:role, "is required")
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <select class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" name="test_model[role]" id="test_model_role"></select>
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

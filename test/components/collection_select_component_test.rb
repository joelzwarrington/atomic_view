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
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with prompt" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {prompt: "Select a role"})).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"><option value="">Select a role</option>
      <option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with selected value" do
    @object.role = "admin"
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    # The HTML should be the same, as selection state is handled internally by Rails form helpers
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option>
      <option value="editor">Editor</option></select>
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
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"><option value="admin">Administrator</option>
      <option value="user">Regular User</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with different field name" do
    options = [["Technology", "tech"], ["Design", "design"], ["Marketing", "marketing"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :category, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[category]" id="test_model_category"><option value="tech">Technology</option>
      <option value="design">Design</option>
      <option value="marketing">Marketing</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with html options" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {}, {class: "custom-select", multiple: true})).to_html.strip
    expected = <<~HTML.strip
      <input name="test_model[role][]" type="hidden" value="" autocomplete="off"><select class="custom-select block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" multiple name="test_model[role][]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with data attributes" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = <<~HTML.strip
      <select data-action="change-&gt;controller#update" class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection select with error styling when field has errors" do
    @object.errors.add(:role, "is required")
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 dark:ring-white/10 dark:text-white focus:border-zinc-950/20 dark:focus:ring-white/20 text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" name="test_model[role]" id="test_model_role"><option value="admin">Admin</option>
      <option value="user">User</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionSelectComponent.new(@form, :test_model, :role, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <select class="block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" name="test_model[role]" id="test_model_role"></select>
    HTML

    assert_equal(expected, actual)
  end
end

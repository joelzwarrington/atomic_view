# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CollectionRadioButtonsComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :role, :string
    attribute :status, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic collection radio buttons" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Admin</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">User</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"editor\" name=\"test_model[role]\" id=\"test_model_role_editor\"><label for=\"test_model_role_editor\">Editor</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with selected value" do
    @object.role = "admin"
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Admin</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">User</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"editor\" name=\"test_model[role]\" id=\"test_model_role_editor\"><label for=\"test_model_role_editor\">Editor</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with custom html options" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {class: "custom-radio"})).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"custom-radio peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Admin</label></div><div class=\"flex items-center gap-2\"><input class=\"custom-radio peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">User</label></div><div class=\"flex items-center gap-2\"><input class=\"custom-radio peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"editor\" name=\"test_model[role]\" id=\"test_model_role_editor\"><label for=\"test_model_role_editor\">Editor</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with object collection" do
    roles = [
      OpenStruct.new(name: "Administrator", value: "admin"),
      OpenStruct.new(name: "Regular User", value: "user")
    ]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, roles, :value, :name)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Administrator</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">Regular User</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with different field name" do
    options = [["Active", "active"], ["Inactive", "inactive"], ["Pending", "pending"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :status, options, :second, :first)).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[status]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"active\" name=\"test_model[status]\" id=\"test_model_status_active\"><label for=\"test_model_status_active\">Active</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"inactive\" name=\"test_model[status]\" id=\"test_model_status_inactive\"><label for=\"test_model_status_inactive\">Inactive</label></div><div class=\"flex items-center gap-2\"><input class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"pending\" name=\"test_model[status]\" id=\"test_model_status_pending\"><label for=\"test_model_status_pending\">Pending</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with data attributes" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input data-action=\"change->controller#update\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Admin</label></div><div class=\"flex items-center gap-2\"><input data-action=\"change->controller#update\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">User</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with required attribute" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {required: true})).to_html.strip
    expected = "<div class=\"flex flex-col gap-2\">\n  <input type=\"hidden\" name=\"test_model[role]\" value=\"\" autocomplete=\"off\"><div class=\"flex items-center gap-2\"><input required=\"required\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"admin\" name=\"test_model[role]\" id=\"test_model_role_admin\"><label for=\"test_model_role_admin\">Admin</label></div><div class=\"flex items-center gap-2\"><input required=\"required\" class=\"peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50\" type=\"radio\" value=\"user\" name=\"test_model[role]\" id=\"test_model_role_user\"><label for=\"test_model_role_user\">User</label></div>\n</div>"

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <div class="flex flex-col gap-2">
        <input type="hidden" name="test_model[role]" value="" autocomplete="off">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

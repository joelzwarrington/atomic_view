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
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Admin</label><input type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">User</label><input type="radio" value="editor" name="test_model[role]" id="test_model_role_editor"><label for="test_model_role_editor">Editor</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with selected value" do
    @object.role = "admin"
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Admin</label><input type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">User</label><input type="radio" value="editor" name="test_model[role]" id="test_model_role_editor"><label for="test_model_role_editor">Editor</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with custom html options" do
    options = [["Admin", "admin"], ["User", "user"], ["Editor", "editor"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {class: "custom-radio"})).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input class="custom-radio" type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Admin</label><input class="custom-radio" type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">User</label><input class="custom-radio" type="radio" value="editor" name="test_model[role]" id="test_model_role_editor"><label for="test_model_role_editor">Editor</label>
    HTML

    assert_equal(actual, expected)
  end

  test "renders collection radio buttons with object collection" do
    roles = [
      OpenStruct.new(name: "Administrator", value: "admin"),
      OpenStruct.new(name: "Regular User", value: "user")
    ]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, roles, :value, :name)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Administrator</label><input type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">Regular User</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with different field name" do
    options = [["Active", "active"], ["Inactive", "inactive"], ["Pending", "pending"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :status, options, :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[status]" value="" autocomplete="off"><input type="radio" value="active" name="test_model[status]" id="test_model_status_active"><label for="test_model_status_active">Active</label><input type="radio" value="inactive" name="test_model[status]" id="test_model_status_inactive"><label for="test_model_status_inactive">Inactive</label><input type="radio" value="pending" name="test_model[status]" id="test_model_status_pending"><label for="test_model_status_pending">Pending</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with data attributes" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input data-action="change-&gt;controller#update" type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Admin</label><input data-action="change-&gt;controller#update" type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">User</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders collection radio buttons with required attribute" do
    options = [["Admin", "admin"], ["User", "user"]]
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, options, :second, :first, {}, {required: true})).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off"><input required="required" type="radio" value="admin" name="test_model[role]" id="test_model_role_admin"><label for="test_model_role_admin">Admin</label><input required="required" type="radio" value="user" name="test_model[role]" id="test_model_role_user"><label for="test_model_role_user">User</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders empty collection gracefully" do
    actual = render_inline(AtomicView::Components::CollectionRadioButtonsComponent.new(@form, :test_model, :role, [], :second, :first)).to_html.strip
    expected = <<~HTML.strip
      <input type="hidden" name="test_model[role]" value="" autocomplete="off">
    HTML

    assert_equal(expected, actual)
  end
end

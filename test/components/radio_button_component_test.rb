# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::RadioButtonComponentTest < ViewComponent::TestCase
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
    @object = TestModel.new(role: "admin")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders radio button component" do
    actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :role, "admin")).to_html.strip
    expected = <<~HTML.strip
      <input type="radio" value="admin" name="test_model[role]" id="test_model_role_admin">
    HTML

    assert_equal(expected, actual)
  end

  test "renders radio button with different values" do
    admin_actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :role, "admin")).to_html.strip
    user_actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :role, "user")).to_html.strip

    admin_expected = <<~HTML.strip
      <input type="radio" value="admin" name="test_model[role]" id="test_model_role_admin">
    HTML

    user_expected = <<~HTML.strip
      <input type="radio" value="user" name="test_model[role]" id="test_model_role_user">
    HTML

    assert_equal(admin_expected, admin_actual)
    assert_equal(user_expected, user_actual)
  end

  test "renders radio button with custom options" do
    actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :status, "active", {
      class: "custom-radio",
      required: true
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="custom-radio" required="required" type="radio" value="active" name="test_model[status]" id="test_model_status_active">
    HTML

    assert_equal(expected, actual)
  end

  test "renders radio button with data attributes" do
    actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :role, "admin", {
      data: {action: "change->controller#update"}
    })).to_html.strip
    expected = <<~HTML.strip
      <input data-action="change-&gt;controller#update" type="radio" value="admin" name="test_model[role]" id="test_model_role_admin">
    HTML

    assert_equal(expected, actual)
  end

  test "renders radio button for different attribute" do
    actual = render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :status, "inactive")).to_html.strip
    expected = <<~HTML.strip
      <input type="radio" value="inactive" name="test_model[status]" id="test_model_status_inactive">
    HTML

    assert_equal(expected, actual)
  end

  test "renders multiple radio buttons for same attribute" do
    options = ["draft", "published", "archived"]
    actuals = options.map do |option|
      render_inline(AtomicView::Components::RadioButtonComponent.new(@form, :test_model, :status, option)).to_html.strip
    end

    draft_expected = <<~HTML.strip
      <input type="radio" value="draft" name="test_model[status]" id="test_model_status_draft">
    HTML

    published_expected = <<~HTML.strip
      <input type="radio" value="published" name="test_model[status]" id="test_model_status_published">
    HTML

    archived_expected = <<~HTML.strip
      <input type="radio" value="archived" name="test_model[status]" id="test_model_status_archived">
    HTML

    assert_equal(draft_expected, actuals[0])
    assert_equal(published_expected, actuals[1])
    assert_equal(archived_expected, actuals[2])
  end
end

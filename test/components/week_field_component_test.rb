# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::WeekFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :birth_week, :date
    attribute :project_week, :date

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(birth_week: Date.new(1990, 5, 15))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic week field" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week)).to_html.strip
    expected = <<~HTML.strip
      <input type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with min and max attributes" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {
      min: "2023-W01",
      max: "2024-W52"
    })).to_html.strip
    expected = <<~HTML.strip
      <input min="2023-W01" max="2024-W52" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with custom options" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {
      class: "custom-week-field",
      required: true,
      step: 1
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="custom-week-field" required="required" step="1" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with data attributes" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {
      data: {action: "input->controller#update", target: "form.weekField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <input data-action="input-&gt;controller#update" data-target="form.weekField" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with different attribute name" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :project_week)).to_html.strip
    expected = <<~HTML.strip
      <input type="week" name="test_model[project_week]" id="test_model_project_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with disabled attribute" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <input disabled type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with readonly attribute" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <input readonly type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with pattern attribute" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {pattern: "[0-9]{4}-W[0-9]{2}"})).to_html.strip
    expected = <<~HTML.strip
      <input pattern="[0-9]{4}-W[0-9]{2}" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with list attribute" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {list: "week-suggestions"})).to_html.strip
    expected = <<~HTML.strip
      <input list="week-suggestions" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end

  test "renders week field with value attribute" do
    actual = render_inline(AtomicView::Components::WeekFieldComponent.new(@form, :test_model, :birth_week, {value: "2024-W20"})).to_html.strip
    expected = <<~HTML.strip
      <input value="2024-W20" type="week" name="test_model[birth_week]" id="test_model_birth_week">
    HTML

    assert_equal(expected, actual)
  end
end

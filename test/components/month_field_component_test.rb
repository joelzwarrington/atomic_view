# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::MonthFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :birth_month, :date
    attribute :contract_month, :date

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(birth_month: Date.new(1990, 5, 1))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic month field" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month)).to_html.strip
    expected = <<~HTML.strip
      <input type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with min and max attributes" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {
      min: "2020-01",
      max: "2030-12"
    })).to_html.strip
    expected = <<~HTML.strip
      <input type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with custom options" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {
      class: "custom-month-field",
      required: true,
      step: 1
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="custom-month-field" required="required" step="1" type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with data attributes" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {
      data: {action: "input->controller#update", target: "form.monthField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <input data-action="input-&gt;controller#update" data-target="form.monthField" type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with different attribute name" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :contract_month)).to_html.strip
    expected = <<~HTML.strip
      <input type="month" name="test_model[contract_month]" id="test_model_contract_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with disabled attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <input disabled type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with readonly attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <input readonly type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with pattern attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {pattern: "[0-9]{4}-[0-9]{2}"})).to_html.strip
    expected = <<~HTML.strip
      <input pattern="[0-9]{4}-[0-9]{2}" type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with list attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {list: "month-suggestions"})).to_html.strip
    expected = <<~HTML.strip
      <input list="month-suggestions" type="month" name="test_model[birth_month]" id="test_model_birth_month">
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DatetimeLocalFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :appointment_time, :datetime
    attribute :event_time, :datetime

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(appointment_time: DateTime.new(2023, 12, 25, 14, 30))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic datetime local field" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time)).to_html.strip
    expected = <<~HTML.strip
      <input type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with step attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {step: 60})).to_html.strip
    expected = <<~HTML.strip
      <input step="60" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with min and max attributes" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {
      min: "2023-01-01T00:00",
      max: "2024-12-31T23:59"
    })).to_html.strip
    expected = <<~HTML.strip
      <input min="2023-01-01T00:00:00" max="2024-12-31T23:59:00" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with custom options" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {
      class: "custom-datetime-field",
      required: true,
      step: 1
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="custom-datetime-field" required="required" step="1" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with data attributes" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {
      data: {action: "input->controller#update", target: "form.datetimeField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <input data-action="input-&gt;controller#update" data-target="form.datetimeField" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with different attribute name" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :event_time)).to_html.strip
    expected = <<~HTML.strip
      <input type="datetime-local" name="test_model[event_time]" id="test_model_event_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with disabled attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <input disabled type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with readonly attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <input readonly type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with precision steps" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {step: 0.001})).to_html.strip
    expected = <<~HTML.strip
      <input step="0.001" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
    HTML

    assert_equal(expected, actual)
  end
end

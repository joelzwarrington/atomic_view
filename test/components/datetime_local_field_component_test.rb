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
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with step attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {step: 60})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input step="60" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with min and max attributes" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {
      min: "2023-01-01T00:00",
      max: "2024-12-31T23:59"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input min="2023-01-01T00:00:00" max="2024-12-31T23:59:00" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
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
      <div class="relative rounded-btn shadow-xs">
        <input class="custom-datetime-field block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" required="required" step="1" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with data attributes" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {
      data: {action: "input->controller#update", target: "form.datetimeField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input data-action="input->controller#update" data-target="form.datetimeField" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with different attribute name" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :event_time)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[event_time]" id="test_model_event_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with disabled attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input disabled="disabled" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with readonly attribute" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input readonly="readonly" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with error styling when field has errors" do
    @object.errors.add(:appointment_time, "is required")

    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders datetime local field with precision steps" do
    actual = render_inline(AtomicView::Components::DatetimeLocalFieldComponent.new(@form, :test_model, :appointment_time, {step: 0.001})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-btn shadow-xs">
        <input step="0.001" class="block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="datetime-local" name="test_model[appointment_time]" id="test_model_appointment_time">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

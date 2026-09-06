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
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with min and max attributes" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {
      min: "2020-01",
      max: "2030-12"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
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
      <div class="relative rounded-lg shadow-xs">
        <input class="custom-month-field block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" required="required" step="1" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with data attributes" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {
      data: {action: "input->controller#update", target: "form.monthField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input data-action="input-&gt;controller#update" data-target="form.monthField" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with different attribute name" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :contract_month)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[contract_month]" id="test_model_contract_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with disabled attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input disabled class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with readonly attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input readonly class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with pattern attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {pattern: "[0-9]{4}-[0-9]{2}"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input pattern="[0-9]{4}-[0-9]{2}" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with list attribute" do
    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month, {list: "month-suggestions"})).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input list="month-suggestions" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="month" name="test_model[birth_month]" id="test_model_birth_month">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders month field with error styling when field has errors" do
    @object.errors.add(:birth_month, "is required")

    actual = render_inline(AtomicView::Components::MonthFieldComponent.new(@form, :test_model, :birth_month)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring pr-10" type="month" name="test_model[birth_month]" id="test_model_birth_month">
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
              <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon" class="size-5 text-destructive">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd"></path>
      </svg>

            </div>
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DateFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :birthdate, :date
    attribute :start_date, :date

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(birthdate: Date.new(1990, 5, 15))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic date field" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate)).to_html.strip
    expected = <<~HTML.strip
      <input class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with min and max attributes" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate, {min: "1900-01-01", max: "2030-12-31"})).to_html.strip
    expected = <<~HTML.strip
      <input min="1900-01-01" max="2030-12-31" class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with custom options" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate, {
      class: "custom-date-field",
      required: true,
      step: 1
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="custom-date-field block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" required="required" step="1" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with data attributes" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate, {
      data: {action: "input->controller#update", target: "form.dateField"}
    })).to_html.strip
    expected = <<~HTML.strip
      <input data-action="input-&gt;controller#update" data-target="form.dateField" class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with error styling when field has errors" do
    @object.errors.add(:birthdate, "is required")
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate)).to_html.strip
    expected = <<~HTML.strip
      <input class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 dark:ring-white/10 dark:text-white focus:border-zinc-950/20 dark:focus:ring-white/20 text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with different attribute name" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :start_date)).to_html.strip
    expected = <<~HTML.strip
      <input class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[start_date]" id="test_model_start_date">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with disabled attribute" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <input disabled class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end

  test "renders date field with readonly attribute" do
    actual = render_inline(AtomicView::Components::DateFieldComponent.new(@form, :test_model, :birthdate, {readonly: true})).to_html.strip
    expected = <<~HTML.strip
      <input readonly class="block w-full h-9 min-w-0 flex-1 rounded-sm border-0 py-1 text-sm shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="date" name="test_model[birthdate]" id="test_model_birthdate">
    HTML

    assert_equal(expected, actual)
  end
end
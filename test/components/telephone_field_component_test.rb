# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TelephoneFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :phone, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(phone: "+1-555-123-4567")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders telephone field component" do
    actual = render_inline(AtomicView::Components::TelephoneFieldComponent.new(@form, :test_model, :phone)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="tel" name="test_model[phone]" id="test_model_phone">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders telephone field with custom options" do
    actual = render_inline(AtomicView::Components::TelephoneFieldComponent.new(@form, :test_model, :phone, {
      placeholder: "+1-555-000-0000",
      pattern: "[0-9]{3}-[0-9]{3}-[0-9]{4}"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input placeholder="+1-555-000-0000" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="tel" name="test_model[phone]" id="test_model_phone">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders telephone field with container styling" do
    actual = render_inline(AtomicView::Components::TelephoneFieldComponent.new(@form, :test_model, :phone)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring" type="tel" name="test_model[phone]" id="test_model_phone">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders telephone field with error styling when field has errors" do
    @object.errors.add(:phone, "is not a valid phone number")

    actual = render_inline(AtomicView::Components::TelephoneFieldComponent.new(@form, :test_model, :phone)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 dark:text-white focus:border-ring/20 dark:focus:ring-focus-ring pr-10 text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" type="tel" name="test_model[phone]" id="test_model_phone">
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

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TextAreaComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :description, :string
    attribute :content, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(description: "Sample description")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders text area component" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description)).to_html.strip
    expected = "<textarea class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[description]\" id=\"test_model_description\"></textarea>"

    assert_equal(expected, actual)
  end

  test "renders text area with custom options" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :content, {
      placeholder: "Enter your content here",
      rows: 10,
      cols: 50
    })).to_html.strip
    expected = "<textarea placeholder=\"Enter your content here\" rows=\"10\" cols=\"50\" class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[content]\" id=\"test_model_content\"></textarea>"

    assert_equal(expected, actual)
  end

  test "renders text area with basic html structure" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description)).to_html.strip
    expected = "<textarea class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[description]\" id=\"test_model_description\"></textarea>"

    assert_equal(expected, actual)
  end

  test "renders text area with data attributes" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description, {
      data: {action: "input->controller#update"}
    })).to_html.strip
    expected = "<textarea data-action=\"input->controller#update\" class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[description]\" id=\"test_model_description\"></textarea>"

    assert_equal(expected, actual)
  end

  test "renders text area for correct field" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :content)).to_html.strip
    expected = "<textarea class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[content]\" id=\"test_model_content\"></textarea>"

    assert_equal(expected, actual)
  end

  test "renders text area with error styling when field has errors" do
    @object.errors.add(:description, "is too short")

    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description)).to_html.strip
    expected = "<textarea class=\"block w-full appearance-none min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-base disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 dark:ring-white/10 focus:border-ring/20 dark:focus:ring-focus-ring text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring h-auto min-h-24 resize-y\" name=\"test_model[description]\" id=\"test_model_description\"></textarea>"

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::SubmitComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(name: "Test User")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders submit button with default text" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, nil))

    assert_includes result.to_html, "<input"
    assert_includes result.to_html, 'type="submit"'
  end

  test "renders submit button with custom text" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Save Changes"))

    assert_includes result.to_html, 'value="Save Changes"'
  end

  test "renders submit button with default styling" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit"))

    assert_includes result.to_html, "cursor-pointer rounded-md"
    assert_includes result.to_html, "bg-green-600"
    assert_includes result.to_html, "text-white shadow-xs"
    assert_includes result.to_html, "hover:bg-green-600/90"
  end

  test "renders submit button with custom options" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      class: "custom-submit",
      id: "submit-button",
      disabled: true
    }))

    assert_includes result.to_html, 'id="submit-button"'
    assert_includes result.to_html, "disabled"
  end

  test "renders submit button with data attributes" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      data: {confirm: "Are you sure?", disable_with: "Submitting..."}
    }))

    assert_includes result.to_html, 'data-confirm="Are you sure?"'
    assert_includes result.to_html, 'data-disable-with="Submitting..."'
  end

  test "renders submit button with form attribute" do
    result = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      form: "my-form"
    }))

    assert_includes result.to_html, 'form="my-form"'
  end
end

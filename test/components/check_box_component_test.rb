# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CheckBoxComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :active, :boolean
    attribute :terms_accepted, :boolean

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(active: true)
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders checkbox component" do
    actual = render_inline(AtomicView::Components::CheckBoxComponent.new(@form, :test_model, :active, "1", "0")).to_html.strip
    expected = <<~HTML.strip
      <input name="test_model[active]" type="hidden" value="0" autocomplete="off"><input class="h-4 w-4 rounded-sm border-neutral-300 text-blue-500 focus:ring-blue-700 hover:border-neutral-700" type="checkbox" value="1" name="test_model[active]" id="test_model_active">
    HTML

    assert_equal(expected, actual)
  end

  test "renders checkbox with custom options" do
    actual = render_inline(AtomicView::Components::CheckBoxComponent.new(@form, :test_model, :terms_accepted, "1", "0", {
      class: "custom-checkbox",
      required: true
    })).to_html.strip
    expected = <<~HTML.strip
      <input name="test_model[terms_accepted]" type="hidden" value="0" autocomplete="off"><input class="custom-checkbox h-4 w-4 rounded-sm border-neutral-300 text-blue-500 focus:ring-blue-700 hover:border-neutral-700" required="required" type="checkbox" value="1" name="test_model[terms_accepted]" id="test_model_terms_accepted">
    HTML

    assert_equal(expected, actual)
  end

  test "renders checkbox with custom checked and unchecked values" do
    actual = render_inline(AtomicView::Components::CheckBoxComponent.new(@form, :test_model, :active, "yes", "no")).to_html.strip
    expected = <<~HTML.strip
      <input name="test_model[active]" type="hidden" value="no" autocomplete="off"><input class="h-4 w-4 rounded-sm border-neutral-300 text-blue-500 focus:ring-blue-700 hover:border-neutral-700" type="checkbox" value="yes" name="test_model[active]" id="test_model_active">
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ColorFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :favorite_color, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(favorite_color: "#ff0000")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders color field component" do
    actual = render_inline(AtomicView::Components::ColorFieldComponent.new(@form, :test_model, :favorite_color)).to_html.strip
    expected = <<~HTML.strip
      <input value="#000000" type="color" name="test_model[favorite_color]" id="test_model_favorite_color">
    HTML

    assert_equal(expected, actual)
  end

  test "renders color field with custom options" do
    actual = render_inline(AtomicView::Components::ColorFieldComponent.new(@form, :test_model, :favorite_color, {
      class: "color-picker",
      title: "Choose your favorite color"
    })).to_html.strip
    expected = <<~HTML.strip
      <input class="color-picker" title="Choose your favorite color" value="#000000" type="color" name="test_model[favorite_color]" id="test_model_favorite_color">
    HTML

    assert_equal(expected, actual)
  end

  test "renders color field with basic html structure" do
    actual = render_inline(AtomicView::Components::ColorFieldComponent.new(@form, :test_model, :favorite_color)).to_html.strip
    expected = <<~HTML.strip
      <input value="#000000" type="color" name="test_model[favorite_color]" id="test_model_favorite_color">
    HTML

    assert_equal(expected, actual)
  end

  test "renders color field for correct attribute" do
    actual = render_inline(AtomicView::Components::ColorFieldComponent.new(@form, :test_model, :favorite_color)).to_html.strip
    expected = <<~HTML.strip
      <input value="#000000" type="color" name="test_model[favorite_color]" id="test_model_favorite_color">
    HTML

    assert_equal(expected, actual)
  end
end

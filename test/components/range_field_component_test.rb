# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::RangeFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :volume, :integer

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(volume: 50)
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders range field component" do
    actual = render_inline(AtomicView::Components::RangeFieldComponent.new(@form, :test_model, :volume)).to_html.strip
    expected = <<~HTML.strip
      <input type="range" name="test_model[volume]" id="test_model_volume">
    HTML

    assert_equal(expected, actual)
  end

  test "renders range field with min, max, and step" do
    actual = render_inline(AtomicView::Components::RangeFieldComponent.new(@form, :test_model, :volume, {
      min: 0,
      max: 100,
      step: 5
    })).to_html.strip
    expected = <<~HTML.strip
      <input min="0" max="100" step="5" type="range" name="test_model[volume]" id="test_model_volume">
    HTML

    assert_equal(expected, actual)
  end

  test "renders range field with basic html structure" do
    actual = render_inline(AtomicView::Components::RangeFieldComponent.new(@form, :test_model, :volume)).to_html.strip
    expected = <<~HTML.strip
      <input type="range" name="test_model[volume]" id="test_model_volume">
    HTML

    assert_equal(expected, actual)
  end
end

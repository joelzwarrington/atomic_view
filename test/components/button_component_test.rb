# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::ButtonComponentTest < ViewComponent::TestCase
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

  test "renders button with string label" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {})).to_html.strip
    expected = <<~HTML.strip
      <button>Submit</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with custom options" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      class: "custom-button",
      id: "submit-btn",
      disabled: true
    })).to_html.strip
    expected = <<~HTML.strip
      <button class="custom-button" id="submit-btn" disabled>Submit</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with block content" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {})) do
      "Custom Button Content"
    end.to_html.strip
    expected = <<~HTML.strip
      <button>Custom Button Content</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with only options and block content" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, nil, {class: "btn-block"})) do
      "Block Content Only"
    end.to_html.strip
    expected = <<~HTML.strip
      <button class="btn-block">Block Content Only</button>
    HTML

    assert_equal(expected, actual)
  end

  test "renders button with data attributes" do
    actual = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      data: {confirm: "Are you sure?", method: :delete}
    })).to_html.strip
    expected = <<~HTML.strip
      <button data-confirm="Are you sure?" data-method="delete">Submit</button>
    HTML

    assert_equal(expected, actual)
  end
end

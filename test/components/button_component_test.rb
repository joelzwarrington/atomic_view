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
    result = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {}))

    assert_equal result.to_html.strip, <<~HTML.strip
      <button>Submit</button>
    HTML
  end

  test "renders button with custom options" do
    result = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      class: "custom-button",
      id: "submit-btn",
      disabled: true
    }))

    assert_equal result.to_html.strip, <<~HTML.strip
      <button class="custom-button" id="submit-btn" disabled>Submit</button>
    HTML
  end

  test "renders button with block content" do
    result = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {})) do
      "Custom Button Content"
    end

    assert_equal result.to_html.strip, <<~HTML.strip
      <button>Custom Button Content</button>
    HTML
  end

  test "renders button with only options and block content" do
    result = render_inline(AtomicView::Components::ButtonComponent.new(@form, nil, {class: "btn-block"})) do
      "Block Content Only"
    end

    assert_equal result.to_html.strip, <<~HTML.strip
      <button class="btn-block">Block Content Only</button>
    HTML
  end

  test "renders button with data attributes" do
    result = render_inline(AtomicView::Components::ButtonComponent.new(@form, "Submit", {
      data: {confirm: "Are you sure?", method: :delete}
    }))

    assert_equal result.to_html.strip, <<~HTML.strip
      <button data-confirm="Are you sure?" data-method="delete">Submit</button>
    HTML
  end
end

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
    expected = <<~HTML.strip
      <textarea name="test_model[description]" id="test_model_description">
      </textarea>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text area with custom options" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :content, {
      placeholder: "Enter your content here",
      rows: 10,
      cols: 50
    })).to_html.strip
    expected = <<~HTML.strip
      <textarea placeholder="Enter your content here" rows="10" cols="50" name="test_model[content]" id="test_model_content">
      </textarea>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text area with basic html structure" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description)).to_html.strip
    expected = <<~HTML.strip
      <textarea name="test_model[description]" id="test_model_description">
      </textarea>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text area with data attributes" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :description, {
      data: {action: "input->controller#update"}
    })).to_html.strip
    expected = <<~HTML.strip
      <textarea data-action="input-&gt;controller#update" name="test_model[description]" id="test_model_description">
      </textarea>
    HTML

    assert_equal(expected, actual)
  end

  test "renders text area for correct field" do
    actual = render_inline(AtomicView::Components::TextAreaComponent.new(@form, :test_model, :content)).to_html.strip
    expected = <<~HTML.strip
      <textarea name="test_model[content]" id="test_model_content">
      </textarea>
    HTML

    assert_equal(expected, actual)
  end
end

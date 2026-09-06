# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::LabelComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders label component" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <label class="block text-foreground text-sm font-medium leading-6 mb-2" for="test_model_name">Name</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with custom text" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name, "Full Name:")).to_html.strip
    expected = <<~HTML.strip
      <label class="block text-foreground text-sm font-medium leading-6 mb-2" for="test_model_name">Full Name:</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with default styling" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name)).to_html.strip
    expected = <<~HTML.strip
      <label class="block text-foreground text-sm font-medium leading-6 mb-2" for="test_model_name">Name</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with custom options" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :email, "Email Address", {
      class: "custom-label",
      id: "email-label"
    })).to_html.strip
    expected = <<~HTML.strip
      <label class="custom-label block text-foreground text-sm font-medium leading-6 mb-2" id="email-label" for="test_model_email">Email Address</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with block content" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name)) do
      "Name <span class=\"required\">*</span>".html_safe
    end.to_html.strip
    expected = <<~HTML.strip
      <label class="block text-foreground text-sm font-medium leading-6 mb-2" for="test_model_name">Name <span class="required">*</span></label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label for correct field" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :email)).to_html.strip
    expected = <<~HTML.strip
      <label class="block text-foreground text-sm font-medium leading-6 mb-2" for="test_model_email">Email</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with caption variant" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name, nil, {variant: :caption})).to_html.strip
    expected = <<~HTML.strip
      <label class="block text-muted-foreground text-xs font-bold uppercase tracking-wide mb-1" for="test_model_name">Name</label>
    HTML

    assert_equal(expected, actual)
  end

  test "renders label with inline variant" do
    actual = render_inline(AtomicView::Components::LabelComponent.new(@form, :test_model, :name, nil, {variant: :inline})).to_html.strip
    expected = <<~HTML.strip
      <label class="text-foreground text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-50" for="test_model_name">Name</label>
    HTML

    assert_equal(expected, actual)
  end
end

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
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, nil)).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" data-disable-with="">
    HTML

    assert_equal(expected, actual)
  end

  test "renders submit button with custom text" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Save Changes")).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Save Changes" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" data-disable-with="Save Changes">
    HTML

    assert_equal(expected, actual)
  end

  test "renders submit button with primary variant styling by default" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit")).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Submit" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" data-disable-with="Submit">
    HTML

    assert_equal(expected, actual)
  end

  test "renders submit button with custom options" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      class: "custom-submit",
      id: "submit-button",
      disabled: true
    })).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Submit" class="custom-submit h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" id="submit-button" disabled data-disable-with="Submit">
    HTML

    assert_equal(expected, actual)
  end

  test "renders submit button with data attributes" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      data: {confirm: "Are you sure?", disable_with: "Submitting..."}
    })).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Submit" data-confirm="Are you sure?" data-disable-with="Submitting..." class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90">
    HTML

    assert_equal(expected, actual)
  end

  test "renders submit button with form attribute" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Submit", {
      form: "my-form"
    })).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Submit" form="my-form" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" data-disable-with="Submit">
    HTML

    assert_equal(expected, actual)
  end

  # Variant tests
  test "renders primary variant" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Primary", {variant: :primary})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Primary" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-primary text-primary-foreground shadow-xs hover:bg-primary/90" data-disable-with="Primary">
    HTML

    assert_equal(expected, actual)
  end

  test "renders secondary variant" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Secondary", {variant: :secondary})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Secondary" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80" data-disable-with="Secondary">
    HTML

    assert_equal(expected, actual)
  end

  test "renders destructive variant" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Delete", {variant: :destructive})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Delete" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-[3px] bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20" data-disable-with="Delete">
    HTML

    assert_equal(expected, actual)
  end

  test "renders muted variant" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Muted", {variant: :muted})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Muted" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-transparent text-muted-foreground hover:bg-muted" data-disable-with="Muted">
    HTML

    assert_equal(expected, actual)
  end

  test "renders link variant" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, "Link", {variant: :link})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="Link" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] text-primary underline-offset-4 hover:underline" data-disable-with="Link">
    HTML

    assert_equal(expected, actual)
  end

  test "handles variant passed as hash option" do
    actual = render_inline(AtomicView::Components::SubmitComponent.new(@form, {variant: :secondary})).to_html.strip
    expected = <<~HTML.strip
      <input type="submit" name="commit" value="" class="h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80" data-disable-with="{}">
    HTML

    assert_equal(expected, actual)
  end
end

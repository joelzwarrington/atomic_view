# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::SearchFieldComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :query, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(query: "search term")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders search field component" do
    actual = render_inline(AtomicView::Components::SearchFieldComponent.new(@form, :test_model, :query)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="search" name="test_model[query]" id="test_model_query">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders search field with custom options" do
    actual = render_inline(AtomicView::Components::SearchFieldComponent.new(@form, :test_model, :query, {
      placeholder: "Search...",
      autocomplete: "off"
    })).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input placeholder="Search..." autocomplete="off" class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="search" name="test_model[query]" id="test_model_query">
      </div>
    HTML

    assert_equal(expected, actual)
  end

  test "renders search field with container styling" do
    actual = render_inline(AtomicView::Components::SearchFieldComponent.new(@form, :test_model, :query)).to_html.strip
    expected = <<~HTML.strip
      <div class="relative rounded-lg shadow-xs">
        <input class="block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200 bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20" type="search" name="test_model[query]" id="test_model_query">
      </div>
    HTML

    assert_equal(expected, actual)
  end
end

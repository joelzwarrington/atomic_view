# frozen_string_literal: true

require "test_helper"
require "ostruct"

class AtomicView::Components::GroupedCollectionSelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :country, :string
    attribute :city, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})

    # Set up grouped data structure
    @continents = [
      OpenStruct.new(name: "North America", countries: [
        OpenStruct.new(name: "United States", code: "us"),
        OpenStruct.new(name: "Canada", code: "ca")
      ]),
      OpenStruct.new(name: "Europe", countries: [
        OpenStruct.new(name: "United Kingdom", code: "uk"),
        OpenStruct.new(name: "Germany", code: "de")
      ])
    ]
  end

  CHROME_CLASS = "block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring"

  test "renders basic grouped collection select" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name)).to_html.strip
    expected = "<select class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[country]\" id=\"test_model_country\"><optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with prompt" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name, {prompt: "Select a country"})).to_html.strip
    expected = "<select class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[country]\" id=\"test_model_country\"><option value=\"\">Select a country</option>\n<optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with selected value" do
    @object.country = "us"
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name)).to_html.strip
    # The HTML should be the same, as selection state is handled internally by Rails form helpers
    expected = "<select class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[country]\" id=\"test_model_country\"><optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with different field name" do
    # Create city data structure
    states = [
      OpenStruct.new(name: "California", cities: [
        OpenStruct.new(name: "San Francisco", id: "sf"),
        OpenStruct.new(name: "Los Angeles", id: "la")
      ]),
      OpenStruct.new(name: "New York", cities: [
        OpenStruct.new(name: "New York City", id: "nyc"),
        OpenStruct.new(name: "Albany", id: "alb")
      ])
    ]

    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :city, states, :cities, :name, :id, :name)).to_html.strip
    expected = "<select class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[city]\" id=\"test_model_city\"><optgroup label=\"California\"><option value=\"sf\">San Francisco</option>\n<option value=\"la\">Los Angeles</option></optgroup><optgroup label=\"New York\"><option value=\"nyc\">New York City</option>\n<option value=\"alb\">Albany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with html options" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name, {}, {class: "custom-select", multiple: true})).to_html.strip
    expected = "<input name=\"test_model[country][]\" type=\"hidden\" value=\"\" autocomplete=\"off\"><select class=\"custom-select block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" multiple=\"multiple\" name=\"test_model[country][]\" id=\"test_model_country\"><optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with data attributes" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = "<select data-action=\"change->controller#update\" class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[country]\" id=\"test_model_country\"><optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders grouped collection select with include_blank" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, @continents, :countries, :name, :code, :name, {include_blank: true})).to_html.strip
    expected = "<select class=\"block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1 text-sm disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring\" name=\"test_model[country]\" id=\"test_model_country\"><option value=\"\" label=\" \"></option>\n<optgroup label=\"North America\"><option value=\"us\">United States</option>\n<option value=\"ca\">Canada</option></optgroup><optgroup label=\"Europe\"><option value=\"uk\">United Kingdom</option>\n<option value=\"de\">Germany</option></optgroup></select>"

    assert_equal(expected, actual)
  end

  test "renders empty grouped collection gracefully" do
    actual = render_inline(AtomicView::Components::GroupedCollectionSelectComponent.new(@form, :test_model, :country, [], :countries, :name, :code, :name)).to_html.strip
    expected = <<~HTML.strip
      <select class="#{CHROME_CLASS}" name="test_model[country]" id="test_model_country"></select>
    HTML

    assert_equal(expected, actual)
  end
end

# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DateSelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :birthdate, :date
    attribute :start_date, :date

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(birthdate: Date.new(1990, 5, 15))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic date select with three dropdowns" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate))

    # Check for the presence of three select elements (year, month, day)
    assert_includes result.to_html, '<select id="test_model_birthdate_1i" name="test_model[birthdate(1i)]">'
    assert_includes result.to_html, '<select id="test_model_birthdate_2i" name="test_model[birthdate(2i)]">'
    assert_includes result.to_html, '<select id="test_model_birthdate_3i" name="test_model[birthdate(3i)]">'

    # Check for month options
    assert_includes result.to_html, '<option value="1">January</option>'
    assert_includes result.to_html, '<option value="12">December</option>'

    # Check for day options
    assert_includes result.to_html, '<option value="1">1</option>'
    assert_includes result.to_html, '<option value="31">31</option>'
  end

  test "renders date select with custom order" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {order: [:month, :day, :year]}))

    html = result.to_html

    # Check that month comes before day in the HTML
    month_pos = html.index("test_model[birthdate(2i)]")
    day_pos = html.index("test_model[birthdate(3i)]")
    year_pos = html.index("test_model[birthdate(1i)]")

    assert month_pos < day_pos, "Month should come before day in custom order"
    assert day_pos < year_pos, "Day should come before year in custom order"
  end

  test "renders date select with prompt option" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {prompt: true}))

    # Check for prompt options
    assert_includes result.to_html, '<option value="">'
  end

  test "renders date select with custom start and end year" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {
      start_year: 1980,
      end_year: 2000
    }))

    # Check for the presence of custom year range
    assert_includes result.to_html, '<option value="1980">1980</option>'
    assert_includes result.to_html, '<option value="2000">2000</option>'
    assert_not_includes result.to_html, '<option value="2030">2030</option>' # Should not include years outside range
  end

  test "renders date select with different attribute name" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :start_date))

    # Check that the field names use the correct attribute
    assert_includes result.to_html, 'name="test_model[start_date(1i)]"'
    assert_includes result.to_html, 'name="test_model[start_date(2i)]"'
    assert_includes result.to_html, 'name="test_model[start_date(3i)]"'
    assert_includes result.to_html, 'id="test_model_start_date_1i"'
  end

  test "renders date select with html options" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {}, {class: "custom-select"}))

    # Check that HTML options are applied to the select elements
    assert_includes result.to_html, 'class="custom-select"'
  end

  test "renders date select with use_month_numbers option" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {use_month_numbers: true}))

    # Should include numeric month values
    assert_includes result.to_html, '<option value="1">1</option>'
    assert_includes result.to_html, '<option value="12">12</option>'
  end

  test "renders date select with include_blank option" do
    result = render_inline(AtomicView::Components::DateSelectComponent.new(@form, :test_model, :birthdate, {include_blank: true}))

    # Check for blank options
    assert_includes result.to_html, '<option value="" label=" "></option>'
  end
end

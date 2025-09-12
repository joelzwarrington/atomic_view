# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::DatetimeSelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :appointment_time, :datetime
    attribute :event_time, :datetime

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(appointment_time: DateTime.new(2023, 12, 25, 14, 30))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic datetime select with five dropdowns" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time)).to_html

    # Check for the presence of five select elements (year, month, day, hour, minute)
    assert_includes actual, '<select id="test_model_appointment_time_1i" name="test_model[appointment_time(1i)]">'
    assert_includes actual, '<select id="test_model_appointment_time_2i" name="test_model[appointment_time(2i)]">'
    assert_includes actual, '<select id="test_model_appointment_time_3i" name="test_model[appointment_time(3i)]">'
    assert_includes actual, '<select id="test_model_appointment_time_4i" name="test_model[appointment_time(4i)]">'
    assert_includes actual, '<select id="test_model_appointment_time_5i" name="test_model[appointment_time(5i)]">'

    # Check for month options
    assert_includes actual, '<option value="1">January</option>'
    assert_includes actual, '<option value="12">December</option>'

    # Check for hour options
    assert_includes actual, '<option value="00">00</option>'
    assert_includes actual, '<option value="23">23</option>'

    # Check for minute options
    assert_includes actual, '<option value="00">00</option>'
    assert_includes actual, '<option value="59">59</option>'

    # Check for the time separator
    assert_includes actual, " : "
  end

  test "renders datetime select with minute step" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {minute_step: 15})).to_html

    # Check that minutes are limited to 15-minute intervals
    assert_includes actual, '<option value="00">00</option>'
    assert_includes actual, '<option value="15">15</option>'
    assert_includes actual, '<option value="30">30</option>'
    assert_includes actual, '<option value="45">45</option>'

    # Should not include other minute values in the minutes dropdown
    minute_select = actual[/test_model_appointment_time_5i.*?<\/select>/m]
    assert_not_includes minute_select, '<option value="05">05</option>'
    assert_not_includes minute_select, '<option value="59">59</option>'
  end

  test "renders datetime select with custom order" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {order: [:month, :day, :year, :hour, :minute]})).to_html

    # Check that month comes before day in the HTML
    month_pos = actual.index("test_model[appointment_time(2i)]")
    day_pos = actual.index("test_model[appointment_time(3i)]")
    year_pos = actual.index("test_model[appointment_time(1i)]")
    hour_pos = actual.index("test_model[appointment_time(4i)]")

    assert month_pos < day_pos, "Month should come before day in custom order"
    assert day_pos < year_pos, "Day should come before year in custom order"
    assert year_pos < hour_pos, "Year should come before hour in custom order"
  end

  test "renders datetime select with prompt option" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {prompt: true})).to_html

    # Check for prompt options in date and time selects
    assert_includes actual, '<option value="">'
  end

  test "renders datetime select with start and end year" do
    # Set object to a year within our range
    @object.appointment_time = DateTime.new(2022, 6, 15, 10, 30)
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {
      start_year: 2020,
      end_year: 2025
    })).to_html

    # Check for the presence of custom year range
    assert_includes actual, '<option value="2020">2020</option>'
    # 2025 should be present (might be selected due to current date)
    assert_includes actual, 'value="2025"'
    assert_not_includes actual, '<option value="2030">2030</option>' # Should not include years outside range
  end

  test "renders datetime select with different attribute name" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :event_time)).to_html

    # Check that the field names use the correct attribute
    assert_includes actual, 'name="test_model[event_time(1i)]"'
    assert_includes actual, 'name="test_model[event_time(2i)]"'
    assert_includes actual, 'name="test_model[event_time(3i)]"'
    assert_includes actual, 'name="test_model[event_time(4i)]"'
    assert_includes actual, 'name="test_model[event_time(5i)]"'
  end

  test "renders datetime select with html options" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {}, {class: "custom-select"})).to_html

    # Check that HTML options are applied to the select elements
    assert_includes actual, 'class="custom-select"'
  end

  test "renders datetime select with include_blank option" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {include_blank: true})).to_html

    # Check for blank options in all selects
    assert_includes actual, '<option value="" label=" "></option>'
  end

  test "renders datetime select with discard year option" do
    actual = render_inline(AtomicView::Components::DatetimeSelectComponent.new(@form, :test_model, :appointment_time, {discard_year: true})).to_html

    # Should not include year select when discarded
    assert_not_includes actual, '<select id="test_model_appointment_time_1i"'

    # Should still include month, day, hour, minute
    assert_includes actual, '<select id="test_model_appointment_time_2i"'
    assert_includes actual, '<select id="test_model_appointment_time_3i"'
    assert_includes actual, '<select id="test_model_appointment_time_4i"'
    assert_includes actual, '<select id="test_model_appointment_time_5i"'
  end
end

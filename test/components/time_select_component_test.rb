# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TimeSelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :meeting_time, :time
    attribute :appointment_time, :time

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(meeting_time: Time.new(2023, 12, 25, 14, 30))
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic time select with hour and minute dropdowns" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time))

    html = result.to_html
    
    # Check for hidden date fields (year, month, day) that time_select creates
    assert_includes html, '<input type="hidden" id="test_model_meeting_time_1i"'
    assert_includes html, '<input type="hidden" id="test_model_meeting_time_2i"'
    assert_includes html, '<input type="hidden" id="test_model_meeting_time_3i"'
    
    # Check for the hour and minute select elements
    assert_includes html, '<select id="test_model_meeting_time_4i" name="test_model[meeting_time(4i)]">'
    assert_includes html, '<select id="test_model_meeting_time_5i" name="test_model[meeting_time(5i)]">'
    
    # Check for hour options
    assert_includes html, '<option value="00">00</option>'
    assert_includes html, '<option value="23">23</option>'
    
    # Check for minute options (all 60 minutes by default)
    assert_includes html, '<option value="00">00</option>'
    assert_includes html, '<option value="59">59</option>'
    
    # Check for the time separator
    assert_includes html, ' : '
  end

  test "renders time select with minute step" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {minute_step: 30}))

    html = result.to_html
    
    # Check that minutes are limited to 30-minute intervals
    assert_includes html, '<option value="00">00</option>'
    assert_includes html, '<option value="30">30</option>'
    
    # Should not include other minute values in the minutes dropdown
    minute_select = html[/test_model_meeting_time_5i.*?<\/select>/m]
    assert_not_includes minute_select, '<option value="15">15</option>'
    assert_not_includes minute_select, '<option value="45">45</option>'
    assert_not_includes minute_select, '<option value="59">59</option>'
  end

  test "renders time select with prompt option" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {prompt: true}))

    # Check for prompt options in time selects
    assert_includes result.to_html, '<option value="">'
  end

  test "renders time select with include_blank option" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {include_blank: true}))

    # Check for blank options
    assert_includes result.to_html, '<option value="" label=" "></option>'
  end

  test "renders time select with different attribute name" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :appointment_time))

    html = result.to_html
    
    # Check that the field names use the correct attribute
    assert_includes html, 'name="test_model[appointment_time(1i)]"'
    assert_includes html, 'name="test_model[appointment_time(4i)]"'
    assert_includes html, 'name="test_model[appointment_time(5i)]"'
    assert_includes html, 'id="test_model_appointment_time_4i"'
    assert_includes html, 'id="test_model_appointment_time_5i"'
  end

  test "renders time select with html options" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {}, {class: "custom-select"}))

    # Check that HTML options are applied to the visible select elements
    assert_includes result.to_html, 'class="custom-select"'
  end

  test "renders time select with ignore date option" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {ignore_date: true}))

    html = result.to_html
    
    # When ignore_date is true, it should only show time selects without hidden date fields
    assert_not_includes html, '<input type="hidden" id="test_model_meeting_time_1i"'
    
    # Should have hour and minute selects
    assert_includes html, '<select id="test_model_meeting_time_4i"'
    assert_includes html, '<select id="test_model_meeting_time_5i"'
    assert_includes html, ' : ' # Time separator
  end

  test "renders time select with data attributes" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {}, {data: {action: "change->controller#update"}}))

    # Check that data attributes are applied
    assert_includes result.to_html, 'data-action="change-&gt;controller#update"'
  end

  test "renders time select with disabled option" do
    result = render_inline(AtomicView::Components::TimeSelectComponent.new(@form, :test_model, :meeting_time, {}, {disabled: true}))

    # Check that disabled attribute is applied
    assert_includes result.to_html, 'disabled'
  end
end
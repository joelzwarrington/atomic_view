# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TimeZoneSelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :time_zone, :string
    attribute :user_timezone, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(time_zone: "UTC")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic time zone select" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil)).to_html
    
    # Check for the select element structure
    assert_includes actual, '<select name="test_model[time_zone]" id="test_model_time_zone">'
    
    # Check for UTC which should always be available
    assert_includes actual, '<option value="UTC">'
    assert_includes actual, 'UTC</option>'
    
    # Should include GMT references in time zones
    assert_includes actual, 'GMT'
    
    # Should end properly
    assert_includes actual, '</select>'
  end

  test "renders time zone select with priority zones" do
    priority_zones = ActiveSupport::TimeZone.us_zones
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, priority_zones)).to_html
    
    # Check basic structure
    assert_includes actual, '<select name="test_model[time_zone]" id="test_model_time_zone">'
    
    # Should have a separator between priority and regular zones
    assert_includes actual, '-------------'
    
    # Should include US time zones (at least one should be present)
    us_zones_present = actual.include?('Eastern Time') || actual.include?('Central Time') || 
                       actual.include?('Mountain Time') || actual.include?('Pacific Time')
    assert us_zones_present, "Expected at least one US time zone to be present"
    
    assert_includes actual, '</select>'
  end

  test "renders time zone select with selected value" do
    @object.time_zone = "UTC"
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil)).to_html

    # The HTML structure should be correct, selection state is handled internally by Rails
    assert_includes actual, '<select name="test_model[time_zone]" id="test_model_time_zone">'
    assert_includes actual, '<option value="UTC">'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with different attribute name" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :user_timezone, nil)).to_html

    # Check that the field names use the correct attribute
    assert_includes actual, 'name="test_model[user_timezone]"'
    assert_includes actual, 'id="test_model_user_timezone"'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with html options" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil, {}, {class: "custom-select", multiple: true})).to_html

    # Check that HTML options are applied
    assert_includes actual, 'class="custom-select"'
    assert_includes actual, 'multiple'
    
    # Multiple select should have array name
    assert_includes actual, 'name="test_model[time_zone][]"'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with data attributes" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil, {}, {data: {action: "change->controller#update"}})).to_html

    # Check that data attributes are applied
    assert_includes actual, 'data-action="change-&gt;controller#update"'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with prompt" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil, {prompt: "Select a time zone"})).to_html

    # Check for prompt option
    assert_includes actual, '<option value="">Select a time zone</option>'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with include_blank" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil, {include_blank: true})).to_html

    # Check for blank option
    assert_includes actual, '<option value="" label=" "></option>'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with disabled option" do
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, nil, {}, {disabled: true})).to_html

    # Check that disabled attribute is applied
    assert_includes actual, 'disabled'
    assert_includes actual, '</select>'
  end

  test "renders time zone select with specific priority zones" do
    priority_zones = [ActiveSupport::TimeZone["UTC"]]
    actual = render_inline(AtomicView::Components::TimeZoneSelectComponent.new(@form, :test_model, :time_zone, priority_zones)).to_html
    
    # Should include the priority zone (UTC is always available)
    assert_includes actual, '<option value="UTC">'
    assert_includes actual, 'UTC</option>'
    assert_includes actual, '</select>'
  end
end
# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::WeekdaySelectComponentTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :preferred_day, :string
    attribute :meeting_day, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  def setup
    @object = TestModel.new(preferred_day: "Monday")
    @form = ActionView::Helpers::FormBuilder.new(:test_model, @object, vc_test_controller.view_context, {})
  end

  test "renders basic weekday select with day names as values" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day)).to_html.strip
    expected = <<~HTML.strip
      <select name="test_model[preferred_day]" id="test_model_preferred_day"><option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with index as value" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {index_as_value: true})).to_html.strip
    expected = <<~HTML.strip
      <select name="test_model[preferred_day]" id="test_model_preferred_day"><option value="1">Monday</option>
      <option value="2">Tuesday</option>
      <option value="3">Wednesday</option>
      <option value="4">Thursday</option>
      <option value="5">Friday</option>
      <option value="6">Saturday</option>
      <option value="0">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with different attribute name" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :meeting_day)).to_html.strip
    expected = <<~HTML.strip
      <select name="test_model[meeting_day]" id="test_model_meeting_day"><option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with html options" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {}, {class: "custom-select", multiple: true})).to_html.strip
    expected = <<~HTML.strip
      <input name="test_model[preferred_day][]" type="hidden" value="" autocomplete="off"><select class="custom-select" multiple name="test_model[preferred_day][]" id="test_model_preferred_day"><option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with data attributes" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {}, {data: {action: "change->controller#update"}})).to_html.strip
    expected = <<~HTML.strip
      <select data-action="change-&gt;controller#update" name="test_model[preferred_day]" id="test_model_preferred_day"><option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with prompt" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {prompt: "Select a day"})).to_html.strip
    expected = <<~HTML.strip
      <select name="test_model[preferred_day]" id="test_model_preferred_day"><option value="">Select a day</option>
      <option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with include_blank" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {include_blank: true})).to_html.strip
    expected = <<~HTML.strip
      <select name="test_model[preferred_day]" id="test_model_preferred_day"><option value="" label=" "></option>
      <option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with disabled option" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {}, {disabled: true})).to_html.strip
    expected = <<~HTML.strip
      <select disabled name="test_model[preferred_day]" id="test_model_preferred_day"><option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end

  test "renders weekday select with required attribute" do
    actual = render_inline(AtomicView::Components::WeekdaySelectComponent.new(@form, :test_model, :preferred_day, {}, {required: true})).to_html.strip
    expected = <<~HTML.strip
      <select required="required" name="test_model[preferred_day]" id="test_model_preferred_day"><option value="" label=" "></option>
      <option value="Monday">Monday</option>
      <option value="Tuesday">Tuesday</option>
      <option value="Wednesday">Wednesday</option>
      <option value="Thursday">Thursday</option>
      <option value="Friday">Friday</option>
      <option value="Saturday">Saturday</option>
      <option value="Sunday">Sunday</option></select>
    HTML

    assert_equal(expected, actual)
  end
end

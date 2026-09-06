# frozen_string_literal: true

require "test_helper"

class AtomicView::FormBuilderTest < ViewComponent::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :preferred_day, :string

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end

  test "weekday_select renders through AtomicView::Components::WeekdaySelectComponent instead of Rails' native helper" do
    object = TestModel.new(preferred_day: "Monday")
    form = AtomicView::FormBuilder.new(:test_model, object, vc_test_controller.view_context, {})

    actual = form.weekday_select(:preferred_day).to_s

    # Rails' native `weekday_select` (added in Rails 7) renders an unstyled
    # <select> with no class attribute. If this test starts failing because
    # `actual` has no class attribute, the override in
    # AtomicView::FormBuilder#weekday_select has stopped forwarding to the
    # ViewComponent-based component.
    assert_includes actual, "rounded-btn"
  end
end

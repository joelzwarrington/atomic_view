# frozen_string_literal: true

module AtomicView
  class FormBuilder < ViewComponent::Form::Builder
    namespace Components

    # view_component-form's Helpers::Rails module forwards most native Rails
    # form helpers to their ViewComponent equivalents, but it misses
    # `weekday_select` (added natively to Rails' FormBuilder in Rails 7).
    # Without this override, `form.weekday_select` would bypass
    # AtomicView::Components::WeekdaySelectComponent entirely and fall back to
    # ActionView's unstyled native helper.
    def weekday_select(method, options = {}, html_options = {})
      render_component(
        :weekday_select, @object_name, method,
        objectify_options(options), @default_html_options.merge(html_options)
      )
    end
  end
end

module AtomicView
  module Components
    class DatetimeSelectComponent < ViewComponent::Form::DatetimeSelectComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        field_chrome_classes(size: :sm)
      end

      def call
        # `ViewComponent::Form::DatetimeSelectComponent#call` builds
        # `ActionView::Helpers::Tags::DatetimeSelect` straight from
        # `object_name`/`method_name` without `options[:object]`, so it
        # resolves the bound object by looking up an `@<object_name>` ivar
        # on the view context instead of using `form.object` -- outside a
        # real `form_for`-rendered view that ivar doesn't exist, so Rails'
        # `DateTimeSelector` silently falls back to `Time.current` instead
        # of the model's actual value. Set it explicitly so the rendered
        # selection always reflects the object, not the clock.
        options[:object] = object

        content_tag(:div, super, class: "flex gap-2")
      end
    end
  end
end

module AtomicView
  module Components
    class DateSelectComponent < ViewComponent::Form::DateSelectComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        field_chrome_classes(size: :sm)
      end

      def call
        content_tag(:div, super, class: "flex gap-2")
      end
    end
  end
end

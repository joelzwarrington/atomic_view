module AtomicView
  module Components
    class TimeSelectComponent < ViewComponent::Form::TimeSelectComponent
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

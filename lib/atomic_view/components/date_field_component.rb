module AtomicView
  module Components
    class DateFieldComponent < ViewComponent::Form::DateFieldComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        class_names(field_chrome_classes(size: :sm), options[:class])
      end
    end
  end
end

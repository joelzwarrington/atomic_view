module AtomicView
  module Components
    class TextAreaComponent < ViewComponent::Form::TextAreaComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        class_names(field_chrome_classes, "h-auto min-h-24 resize-y")
      end
    end
  end
end

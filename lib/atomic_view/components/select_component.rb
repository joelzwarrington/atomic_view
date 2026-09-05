module AtomicView
  module Components
    class SelectComponent < ViewComponent::Form::SelectComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        class_names(field_chrome_classes(size: :sm), options[:class])
      end
    end
  end
end

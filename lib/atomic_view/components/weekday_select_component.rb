module AtomicView
  module Components
    class WeekdaySelectComponent < ViewComponent::Form::WeekdaySelectComponent
      include AtomicView::Components::Concerns::FieldChrome

      def html_class
        field_chrome_classes(size: :sm)
      end
    end
  end
end

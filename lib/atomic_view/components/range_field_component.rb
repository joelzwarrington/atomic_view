module AtomicView
  module Components
    class RangeFieldComponent < ViewComponent::Form::RangeFieldComponent
      def html_class
        "accent-primary h-2 rounded-pill bg-offset"
      end
    end
  end
end

module AtomicView
  module Components
    class ColorFieldComponent < ViewComponent::Form::ColorFieldComponent
      def html_class
        "rounded-well h-8 w-8 border border-border p-1 cursor-pointer"
      end
    end
  end
end

module AtomicView
  module Components
    class LabelComponent < ViewComponent::Form::LabelComponent
      def html_class
        "block text-primary text-sm font-medium leading-6 mb-2"
      end
    end
  end
end

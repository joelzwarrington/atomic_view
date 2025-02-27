module AtomicView
  module Components
    class CheckBoxComponent < ViewComponent::Form::CheckBoxComponent
      def html_class
        "h-4 w-4 rounded-sm border-neutral-300 text-blue-500 focus:ring-blue-700 hover:border-neutral-700"
      end
    end
  end
end

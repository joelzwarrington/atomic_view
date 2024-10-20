module AtomicView
  module Components
    class SubmitComponent < ViewComponent::Form::SubmitComponent
      def html_class
        "cursor-pointer rounded-md bg-green-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-green-600/90 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-700"
      end
    end
  end
end

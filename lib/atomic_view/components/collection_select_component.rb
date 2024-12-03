module AtomicView
  module Components
    class CollectionSelectComponent < ViewComponent::Form::CollectionSelectComponent
      def html_class
        class_names(
          *%W[block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-sm ring-1],
          "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500 disabled:ring-gray-200",
          "text-gray-900 ring-gray-300 placeholder:text-gray-400 focus:ring-neutral-700",
          "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" => method_errors?
        )
      end
    end
  end
end

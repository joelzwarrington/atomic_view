module AtomicView
  module Components
    class DateFieldComponent < ViewComponent::Form::DateFieldComponent
      def html_class
        class_names(
          class_names(
            *%W[block w-full h-9 min-w-0 flex-1 rounded-sm-md border-0 py-1 text-sm shadow-xs ring-1],
            "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200",
            "bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20",
            "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" => method_errors?,
          ),
          options[:class]
        )
      end
    end
  end
end

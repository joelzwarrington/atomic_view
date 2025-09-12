module AtomicView
  module Components
    class SelectComponent < ViewComponent::Form::SelectComponent
      def html_class
        class_names(
          class_names(
            *%W[block w-full h-9 min-w-0 flex-1 rounded-md border-0 py-1 text-sm shadow-xs ring-1],
            "disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring",
            "bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring",
            "text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" => method_errors?
          ),
          options[:class]
        )
      end
    end
  end
end

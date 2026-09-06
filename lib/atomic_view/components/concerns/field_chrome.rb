# frozen_string_literal: true

module AtomicView
  module Components
    module Concerns
      module FieldChrome
        private

        def field_chrome_classes(size: :base)
          class_names(
            "block w-full appearance-none h-8 min-w-0 z-10 flex-1 rounded-btn border-0 py-1 shadow-xs ring-1",
            (size == :sm) ? "text-sm" : "text-base",
            "disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring",
            "bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 placeholder:text-placeholder focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring",
            "text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" => method_errors?
          )
        end
      end
    end
  end
end

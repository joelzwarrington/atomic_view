module AtomicView
  module Components
    class CollectionRadioButtonsComponent < ViewComponent::Form::CollectionRadioButtonsComponent
      def html_class
        "peer border-input dark:bg-input/30 checked:bg-primary checked:text-primary-foreground dark:checked:bg-primary checked:border-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive size-4 shrink-0 rounded-full border shadow-xs transition-shadow outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50"
      end

      def collection_radio_buttons_tag
        ActionView::Helpers::Tags::CollectionRadioButtons.new(
          object_name,
          method_name,
          @view_context,
          collection,
          value_method,
          text_method,
          options,
          html_options,
          &content
        ).render(&element_proc)
      end
    end
  end
end

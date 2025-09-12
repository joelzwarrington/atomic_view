module AtomicView
  module Components
    class FieldComponent < ViewComponent::Form::FieldComponent
      attr_reader :tag_klass

      def initialize(form, object_name, method_name, options = {}, tag_klass = ActionView::Helpers::Tags::TextField)
        super(form, object_name, method_name, options)
        @tag_klass = tag_klass
      end

      def html_class
        class_names(
          "block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-xs ring-1",
          "disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring",
          "bg-transparent dark:bg-white/5 text-primary ring-ring/10 dark:ring-white/10 placeholder:text-placeholder dark:text-white focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring",
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-lg" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-lg" => right_section_addon? || right_section_interaction?,
          "text-error ring-error-ring placeholder:text-error-placeholder focus:ring-error-focus-ring" => method_errors?
        )
      end

      def container_html_class
        class_names(
          "relative rounded-lg shadow-xs",
          {"flex" => left_section_addon? || left_section_interaction? || right_section_addon? || right_section_interaction?},
          options[:container_class]
        )
      end

      def left_section
        options[:left_section]
      end

      def left_section?
        left_section.present?
      end

      def left_section_addon?
        options[:left_section_as_addon].present?
      end

      def left_section_interaction?
        options[:left_section_as_interaction].present?
      end

      def right_section
        options[:right_section] || method_errors? && raw(icon("exclamation-circle", variant: :mini, options: {class: "size-5 text-destructive"}))
      end

      def right_section?
        right_section.present?
      end

      def right_section_addon?
        options[:right_section_as_addon].present?
      end

      def right_section_interaction?
        options[:right_section_as_interaction].present?
      end
    end
  end
end

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
          *%W[block w-full appearance-none h-9 min-w-0 z-10 flex-1 rounded-lg border-0 py-1 text-base shadow-sm ring-1],
          "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-zinc-500 disabled:ring-zinc-200",
          "bg-transparent dark:bg-white/5 text-zinc-950 ring-zinc-950/10 dark:ring-white/10 placeholder:text-zinc-500 dark:text-white focus:ring-neutral-700 focus:border-zinc-950/20 dark:focus:ring-white/20",
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-lg" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-lg" => right_section_addon? || right_section_interaction?,
          "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" => method_errors?
        )
      end

      def container_html_class
        class_names(
          "relative rounded-lg shadow-sm",
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
        options[:right_section] || method_errors? && raw(icon("exclamation-circle", variant: :mini, options: {class: "size-5 text-red-500"}))
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

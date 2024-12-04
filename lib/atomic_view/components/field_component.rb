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
          *%W[block w-full h-9 min-w-0 z-10 flex-1 rounded-md border-0 py-1 text-sm shadow-sm ring-1],
          "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500 disabled:ring-gray-200",
          "text-gray-900 ring-gray-300 placeholder:text-gray-400 focus:ring-neutral-700",
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-md" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-md" => right_section_addon? || right_section_interaction?,
          "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" => method_errors?
        )
      end

      def container_html_class
        class_names(
          "relative rounded-md shadow-sm",
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

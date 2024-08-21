module AtomicView
  module Components
    class TextFieldComponent < ViewComponent::Form::TextFieldComponent
      def html_class
        class_names(
          *%W[block w-full min-w-0 flex-1 rounded-md border-0 py-1.5 shadow-sm ring-1 focus:ring-2 focus:ring-inset sm:text-sm sm:leading-6],
          "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500 disabled:ring-gray-200",
          "text-gray-900 ring-gray-300 placeholder:text-gray-400 focus:ring-blue-600",
          "pl-10" => left_section? && !(left_section_addon? || left_section_button?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_button?),
          "shadow-none ring-inset rounded-none rounded-r-md" => left_section_addon? || left_section_button?,
          "shadow-none ring-inset rounded-none rounded-l-md" => right_section_addon? || right_section_button?,
          "text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500" => method_errors?
        )
      end

      def container_html_class
        class_names(
          "relative rounded-md shadow-sm",
          {"flex" => left_section_addon? || left_section_button? || right_section_addon? || right_section_button?},
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

      def left_section_button?
        options[:left_section_as_button].present?
      end

      def right_section
        options[:right_section] || method_errors? && icon("exclamation-circle", variant: :mini, options: {class: "size-5 text-red-500"})
      end

      def right_section?
        right_section.present?
      end

      def right_section_addon?
        options[:right_section_as_addon].present?
      end

      def right_section_button?
        options[:right_section_as_button].present?
      end
    end
  end
end

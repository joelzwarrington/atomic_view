module AtomicView
  module Components
    class SelectComponent < ViewComponent::Form::SelectComponent
      include AtomicView::Components::Concerns::FieldChrome
      include AtomicView::Components::Concerns::SectionSupport

      def html_class
        class_names(
          field_chrome_classes(size: :sm),
          options[:class],
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-lg" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-lg" => right_section_addon? || right_section_interaction?
        )
      end

      def select_tag
        ActionView::Helpers::Tags::Select.new(
          object_name,
          method_name,
          @view_context,
          choices,
          options,
          html_options,
          &content
        ).render
      end
    end
  end
end

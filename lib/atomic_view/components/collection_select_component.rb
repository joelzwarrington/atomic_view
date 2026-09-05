module AtomicView
  module Components
    class CollectionSelectComponent < ViewComponent::Form::CollectionSelectComponent
      include AtomicView::Components::Concerns::FieldChrome
      include AtomicView::Components::Concerns::SectionSupport

      def html_class
        class_names(
          field_chrome_classes(size: :sm),
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-lg ring-inset" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-lg ring-inset" => right_section_addon? || right_section_interaction?
        )
      end

      def select_tag
        ActionView::Helpers::Tags::CollectionSelect.new(
          object_name,
          method_name,
          @view_context,
          collection,
          value_method,
          text_method,
          options,
          html_options
        ).render
      end
    end
  end
end

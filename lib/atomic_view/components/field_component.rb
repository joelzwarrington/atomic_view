module AtomicView
  module Components
    class FieldComponent < ViewComponent::Form::FieldComponent
      include AtomicView::Components::Concerns::FieldChrome
      include AtomicView::Components::Concerns::SectionSupport

      attr_reader :tag_klass

      def initialize(form, object_name, method_name, options = {}, tag_klass = ActionView::Helpers::Tags::TextField)
        super(form, object_name, method_name, options)
        @tag_klass = tag_klass
      end

      def html_class
        class_names(
          field_chrome_classes,
          "pl-10" => left_section? && !(left_section_addon? || left_section_interaction?),
          "pr-10" => right_section? && !(right_section_addon? || right_section_interaction?),
          "shadow-none rounded-none rounded-r-lg" => left_section_addon? || left_section_interaction?,
          "shadow-none rounded-none rounded-l-lg" => right_section_addon? || right_section_interaction?
        )
      end
    end
  end
end

module AtomicView
  module Components
    class SubmitComponent < ViewComponent::Form::SubmitComponent
      include AtomicView::Components::Concerns::ButtonVariants

      attr_reader :variant

      def initialize(form, value_or_options = nil, options = nil)
        super

        if value_or_options.is_a?(Hash)
          @options = value_or_options
        else
          @options ||= {}
        end

        @variant = @options.delete(:variant) || :primary
      end

      def html_class
        class_names(base_classes, variant_classes, @options[:class])
      end
    end
  end
end

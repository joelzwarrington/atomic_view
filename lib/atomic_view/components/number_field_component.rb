module AtomicView
  module Components
    class NumberFieldComponent < ViewComponent::Form::NumberFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::NumberField
        )
      end
    end
  end
end

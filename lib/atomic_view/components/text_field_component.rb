module AtomicView
  module Components
    class TextFieldComponent < ViewComponent::Form::TextFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options
        )
      end
    end
  end
end

module AtomicView
  module Components
    class PasswordFieldComponent < ViewComponent::Form::PasswordFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::PasswordField
        )
      end
    end
  end
end

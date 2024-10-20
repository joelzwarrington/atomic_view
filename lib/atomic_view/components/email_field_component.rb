module AtomicView
  module Components
    class EmailFieldComponent < ViewComponent::Form::EmailFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::EmailField
        )
      end
    end
  end
end

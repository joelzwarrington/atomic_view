module AtomicView
  module Components
    class TelephoneFieldComponent < ViewComponent::Form::TelephoneFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::TelField
        )
      end
    end
  end
end

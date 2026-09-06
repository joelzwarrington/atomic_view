module AtomicView
  module Components
    class MonthFieldComponent < ViewComponent::Form::MonthFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::MonthField
        )
      end
    end
  end
end

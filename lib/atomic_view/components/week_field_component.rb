module AtomicView
  module Components
    class WeekFieldComponent < ViewComponent::Form::WeekFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::WeekField
        )
      end
    end
  end
end

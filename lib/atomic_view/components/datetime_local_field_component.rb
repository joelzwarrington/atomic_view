module AtomicView
  module Components
    class DatetimeLocalFieldComponent < ViewComponent::Form::DatetimeLocalFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::DatetimeLocalField
        )
      end
    end
  end
end

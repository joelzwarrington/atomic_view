module AtomicView
  module Components
    class UrlFieldComponent < ViewComponent::Form::UrlFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::UrlField
        )
      end
    end
  end
end

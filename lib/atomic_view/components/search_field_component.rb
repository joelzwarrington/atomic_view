module AtomicView
  module Components
    class SearchFieldComponent < ViewComponent::Form::SearchFieldComponent
      def call
        render FieldComponent.new(
          form,
          object_name,
          method_name,
          options,
          ActionView::Helpers::Tags::SearchField
        )
      end
    end
  end
end

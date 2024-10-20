module AtomicView
  module Components
    class EmailFieldComponent < ViewComponent::Form::EmailFieldComponent
      def call
        render TextFieldComponent.new(
          @form,
          @object_name,
          @object_method,
          @options.merge(
            type: "email",
            left_section: icon("at-symbol", variant: :mini, options: {class: "size-5 text-gray-500"})
          )
        )
      end
    end
  end
end

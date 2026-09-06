module AtomicView
  module Components
    class LabelComponent < ViewComponent::Form::LabelComponent
      attr_reader :variant

      def initialize(form, object_name, method_name, content_or_options = nil, options = nil)
        super

        @variant = @options.delete(:variant) || :default
      end

      def html_class
        case variant
        when :caption
          "block text-muted-foreground text-xs font-bold uppercase tracking-wide mb-1"
        else
          "block text-foreground text-sm font-medium leading-6 mb-2"
        end
      end
    end
  end
end

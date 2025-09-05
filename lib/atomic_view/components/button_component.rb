# frozen_string_literal: true

module AtomicView
  module Components
    # Button
    class ButtonComponent < ViewComponent::Form::ButtonComponent
      attr_reader :label, :variant, :size

      def initialize(form, label_or_options = nil, options = nil)
        super

        if label_or_options.is_a?(String)
          @label = label_or_options
          @options ||= {}
        elsif label_or_options.is_a?(Hash)
          @options = label_or_options
        end

        @variant = @options.delete(:variant) || :primary
      end

      def call
        @options[:class] = class_names(base_classes, variant_classes, @options[:class])

        if content?
          content_tag(:button, @options) { content }
        else
          content_tag(:button, label, @options)
        end
      end

      private

      def base_classes
        "h-8 rounded-md px-3 inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]"
      end

      def variant_classes
        case variant
        when :primary
          "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
        when :secondary
          "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80"
        when :destructive
          "bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20"
        when :muted
          "bg-transparent text-muted-foreground hover:bg-muted"
        when :link
          "text-primary underline-offset-4 hover:underline"
        else
          "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
        end
      end
    end
  end
end

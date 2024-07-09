# frozen_string_literal: true

module AtomicView
  module Components
    # Button
    class ButtonComponent < Component
      attr_reader :label, :variant

      def initialize(label_or_options = nil, options = nil)
        super

        if label_or_options.is_a?(Hash)
          options = label_or_options
        else
          @label = label_or_options
          options ||= {}
        end

        options[:class] = opts_to_class
        @options = options
      end

      def call
        if content?
          content_tag(:button, @options) { content }
        else
          content_tag(:button, label, @options)
        end
      end

      private

      def opts_to_class
        class_names("testing")
      end
    end
  end
end

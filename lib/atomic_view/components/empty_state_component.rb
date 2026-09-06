# frozen_string_literal: true

module AtomicView
  module Components
    class EmptyStateComponent < AtomicView::Component
      attr_reader :icon_name, :title, :description

      def initialize(icon_name:, title:, description: nil, **options)
        super()
        @icon_name = icon_name
        @title = title
        @description = description
        @options = options
      end

      private

      def html_class
        class_names(base_classes, @options[:class])
      end

      def base_classes
        "flex flex-col items-center text-center gap-2 p-8"
      end
    end
  end
end

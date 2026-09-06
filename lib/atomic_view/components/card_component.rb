# frozen_string_literal: true

module AtomicView
  module Components
    class CardComponent < AtomicView::Component
      attr_reader :hoverable

      def initialize(hoverable: false, **options)
        super()
        @hoverable = hoverable
        @options = options
      end

      def call
        tag.div(**@options.except(:class), class: class_names(base_classes, hoverable_classes, @options[:class])) { content }
      end

      private

      def base_classes
        "bg-surface rounded-card border border-border p-2.5"
      end

      def hoverable_classes
        "hover:shadow-soft transition-shadow" if hoverable
      end
    end
  end
end

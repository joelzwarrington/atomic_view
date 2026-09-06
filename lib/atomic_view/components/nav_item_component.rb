# frozen_string_literal: true

module AtomicView
  module Components
    class NavItemComponent < AtomicView::Component
      attr_reader :label, :href, :icon_name, :active

      def initialize(label:, href:, icon: nil, active: false, **options)
        super()
        @label = label
        @href = href
        @icon_name = icon
        @active = active
        @options = options
      end

      private

      def html_class
        class_names(base_classes, active ? active_classes : inactive_classes, @options[:class])
      end

      def base_classes
        "flex items-center gap-2 rounded-btn px-3 py-2 text-sm font-medium"
      end

      def active_classes
        "bg-secondary text-secondary-foreground"
      end

      def inactive_classes
        "text-muted-foreground hover:bg-offset hover:text-foreground"
      end
    end
  end
end

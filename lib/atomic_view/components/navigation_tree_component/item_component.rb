# frozen_string_literal: true

module AtomicView
  module Components
    class NavigationTreeComponent
      # A single NavigationTree row: a link when `href:` is given, or a
      # collapsible disclosure (native `<details>`/`<summary>`, no JS) when
      # it's not -- its own `with_item` children then render nested inside
      # it. Rendered via `NavigationTreeComponent#with_item` -- see
      # `NavigationTreeComponent`'s class docs.
      class ItemComponent < AtomicView::Component
        renders_many :items, "AtomicView::Components::NavigationTreeComponent::ItemComponent"

        attr_reader :label, :href, :icon_name, :active

        def initialize(label:, href: nil, icon: nil, active: false, **options)
          super()
          @label = label
          @href = href
          @icon_name = icon
          @active = active
          @options = options
        end

        def group?
          href.nil?
        end

        # A group opens by default when it (or any descendant) is active.
        def open?
          active || items.any? { |item| item.active || item.open? }
        end

        def html_class
          class_names(base_classes, group? ? "cursor-pointer list-none" : nil, active ? active_classes : inactive_classes, @options[:class])
        end

        private

        def base_classes
          "flex items-center gap-2 rounded-btn px-2.5 py-1.5 text-sm font-medium"
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
end

# frozen_string_literal: true

module AtomicView
  module Components
    # NavigationTree
    #
    # A sidebar navigation list -- flat links plus collapsible sections with
    # nested sub-items (native `<details>`/`<summary>`, no JS). Each row is a
    # `with_item` slot so items can nest arbitrarily:
    #
    #   render(NavigationTreeComponent.new(label: "Products")) do |tree|
    #     tree.with_item(label: "Overview", href: "#", icon: "home", active: true)
    #
    #     tree.with_item(label: "Connect", icon: "square-3-stack-3d") do |connect|
    #       connect.with_item(label: "Overview", href: "#")
    #       connect.with_item(label: "Connected accounts", href: "#")
    #     end
    #   end
    #
    # An item given `href:` renders as a link; an item without `href:` renders
    # as a disclosure (a `<summary>` row with a trailing chevron) whose own
    # `with_item` children render nested inside it once open -- see
    # `ItemComponent` for the per-item API.
    #
    # Pass `collapsed: true` for an icon-only rail -- labels, chevrons, and
    # any open group's nested items are hidden with CSS (a `group/nav`
    # marker plus `group-data-[collapsed]/nav:*` variants on each item, the
    # same "no JS" approach as the disclosure groups above), not swapped out
    # in Ruby. Each top-level item is automatically wrapped in a
    # `TooltipComponent` showing its `label:` on hover, since the icon alone
    # loses the item's name -- nested items stay unwrapped, since their
    # container is hidden while collapsed (unreachable in a rail without a
    # flyout, which is out of scope here):
    #
    #   render(NavigationTreeComponent.new(collapsed: true)) do |tree|
    #     tree.with_item(label: "Overview", href: "#", icon: "home", active: true)
    #   end
    class NavigationTreeComponent < AtomicView::Component
      renders_many :items, "ItemComponent"

      attr_reader :label, :tooltip_placement

      def initialize(label: nil, collapsed: false, tooltip_placement: "right", **options)
        super()
        @label = label
        @collapsed = collapsed
        @tooltip_placement = tooltip_placement
        @options = options
      end

      def collapsed?
        @collapsed
      end

      def container_class
        class_names("group/nav flex flex-col gap-1", collapsed? ? "items-center" : nil, @options[:class])
      end

      def html_options
        @options.except(:class, :data)
      end

      def data_attributes
        attributes = @options[:data] || {}
        collapsed? ? attributes.merge(collapsed: true) : attributes
      end
    end
  end
end

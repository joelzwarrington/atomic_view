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
    class NavigationTreeComponent < AtomicView::Component
      renders_many :items, "ItemComponent"

      attr_reader :label

      def initialize(label: nil, **options)
        super()
        @label = label
        @options = options
      end

      def container_class
        class_names("flex flex-col gap-1", @options[:class])
      end
    end
  end
end

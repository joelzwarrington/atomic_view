# frozen_string_literal: true

module AtomicView
  module Components
    # IndexPage
    #
    # The layout shell for a collection page: a PageHeaderComponent up top,
    # an optional `filters` row (e.g. status pills), an optional `toolbar`
    # row below that (search, dropdowns), then either the default content
    # block or an `empty_state` slot, and finally an optional `pagination`
    # slot. This is layout only -- the content region has no idea what's
    # inside it. It doesn't reference TableComponent, doesn't assume rows or
    # columns, and doesn't care whether the caller renders a table, a card
    # grid, or anything else. A smarter, column-aware table is an app-level
    # concern to build on top of this, not something this component owns.
    #
    #   render(AtomicView::Components::IndexPageComponent.new(empty: @rentals.empty?, dom_id: :rentals)) do |page|
    #     page.with_title { "Rentals" }
    #     page.with_subtitle { "#{@rental_count} rentals across #{@park_count} parks" }
    #     page.with_actions { render(LinkComponent.new(new_rental_path)) { "New rental" } }
    #     page.with_filters { render(SegmentedControlComponent.new(options: STATUS_OPTIONS, selected: params[:status] || "All")) }
    #     page.with_toolbar { render(SearchFieldComponent.new(...)) }
    #     page.with_pagination { render(PaginationComponent.new(current_page: @pagy.page, total_pages: @pagy.pages, path_for_page: ->(p) { rentals_path(page: p) })) }
    #     page.with_empty_state { render(EmptyStateComponent.new(title: "No rentals yet")) }
    #
    #     render(AtomicView::Components::TableComponent.new) { ... }
    #   end
    #
    # `breadcrumbs`/`title`/`badge`/`subtitle`/`actions` are forwarded
    # straight into an internally-rendered PageHeaderComponent -- see its
    # docs for what each renders. `empty:` and `dom_id:` stay plain
    # caller-supplied values rather than being derived from a model/Pagy
    # object, so this component never needs to know about ActiveRecord or a
    # pagination library -- an app-level wrapper (e.g. a `ListViewComponent`
    # that already knows about `Pagy`/routes) is the right place to compute
    # them before calling this one.
    class IndexPageComponent < AtomicView::Component
      renders_one :breadcrumbs
      renders_one :title
      renders_one :badge
      renders_one :subtitle
      renders_one :actions
      renders_one :filters
      renders_one :toolbar
      renders_one :empty_state
      renders_one :pagination

      attr_reader :dom_id

      def initialize(empty: false, dom_id: nil, **options)
        super()
        @empty = empty
        @dom_id = dom_id
        @options = options
      end

      def empty? = @empty

      def html_class
        class_names(@options[:class])
      end

      def html_id
        @options[:id] || dom_id
      end
    end
  end
end

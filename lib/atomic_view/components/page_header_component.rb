# frozen_string_literal: true

module AtomicView
  module Components
    # PageHeader
    #
    # The title/breadcrumb/badge/actions cluster shared by IndexPageComponent
    # and PageComponent (and usable standalone, e.g. above a lazily-loaded
    # turbo-frame fragment that has no page shell of its own). Every region is
    # a free-form slot -- this component only lays them out, it has no
    # opinion about hrefs, badge variants, or what an action is.
    #
    #   render(AtomicView::Components::PageHeaderComponent.new) do |header|
    #     header.with_breadcrumbs { link_to "Rentals", rentals_path, class: "text-xs font-semibold text-primary" }
    #     header.with_title { "RS002 · Karen Wilson" }
    #     header.with_badge { render(BadgeComponent.new) { "Active" } }
    #     header.with_subtitle { "rental_9f21ba7c" }
    #     header.with_actions { render(LinkComponent.new(edit_rental_path(@rental), variant: :outline)) { "Edit" } }
    #   end
    #
    # `title` is the one slot every caller is expected to fill -- there's no
    # runtime enforcement of that (this gem doesn't raise on missing slots
    # elsewhere either, e.g. DropdownComponent's `menu`), just a documented
    # expectation. `badge` renders inline right after the title (e.g. a
    # status pill); `subtitle` renders on its own line below (a record count,
    # a copyable reference id); `breadcrumbs` renders above the title as a
    # small eyebrow link; `actions` renders as a button/link cluster on the
    # opposite side of the row, wrapping above the title/breadcrumb column on
    # narrow viewports.
    class PageHeaderComponent < AtomicView::Component
      renders_one :breadcrumbs
      renders_one :title
      renders_one :badge
      renders_one :subtitle
      renders_one :actions

      def initialize(**options)
        super()
        @options = options
      end

      def html_class
        class_names(base_classes, @options[:class])
      end

      private

      def base_classes
        "flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"
      end
    end
  end
end

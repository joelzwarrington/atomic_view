# frozen_string_literal: true

module AtomicView
  module Components
    # Page
    #
    # The layout shell for a single-record page: a PageHeaderComponent up
    # top, an optional full-width `highlight` region below it, then a
    # two-column body -- the default content block as the main column, and an
    # optional `sidebar` slot as a second column. This is layout only -- it
    # has no opinion about what the page actually contains, so it fits show,
    # edit, and new pages alike (a form is just content in the main column).
    # `highlight` is deliberately not called "stepper" or "progress": it's
    # just a full-width slot for whatever sits between the header and the
    # body (a lifecycle stepper, a banner, nothing at all) -- naming it after
    # a specific piece of content would smuggle a content assumption into a
    # layout component. Same reasoning for `sidebar`: it's a column, not a
    # "details panel" -- fill it with a CardComponent, a plain `<dl>`,
    # whatever the record calls for.
    #
    #   render(AtomicView::Components::PageComponent.new) do |page|
    #     page.with_breadcrumbs { link_to "Rentals", rentals_path, class: "text-xs font-semibold text-primary" }
    #     page.with_title { "RS002 · Karen Wilson" }
    #     page.with_badge { render(BadgeComponent.new) { "Active" } }
    #     page.with_actions { render(LinkComponent.new(edit_rental_path(@rental), variant: :outline)) { "Edit" } }
    #     page.with_highlight { render(RentalStepperComponent.new(rental: @rental)) }
    #     page.with_sidebar { render "rentals/details_panel", rental: @rental }
    #
    #     tag.section { tag.h2("Overview", class: "text-lg font-semibold mb-2") + render(CardComponent.new) { @rental.notes } }
    #   end
    #
    # `breadcrumbs`/`title`/`badge`/`subtitle`/`actions` are forwarded
    # straight into an internally-rendered PageHeaderComponent -- see its
    # docs for what each renders. The default content block is the main
    # column; when `sidebar` is omitted, the main column spans full width
    # rather than leaving an empty second column.
    #
    # The two-column grid (sidebar first in document order, reordered after
    # the main column from `sm:` up) matches every existing hand-rolled show
    # page in the consuming app -- that's the "good defaults" this component
    # exists to stop re-typing, not a novel layout choice.
    class PageComponent < AtomicView::Component
      renders_one :breadcrumbs
      renders_one :title
      renders_one :badge
      renders_one :subtitle
      renders_one :actions
      renders_one :highlight
      renders_one :sidebar

      def initialize(**options)
        super()
        @options = options
      end

      def html_class
        class_names(@options[:class])
      end

      def body_class
        class_names("grid grid-cols-1 gap-8", {"sm:grid-cols-3 sm:gap-12" => sidebar?})
      end

      def sidebar_class
        "flex flex-col gap-8 sm:order-2 sm:col-span-1"
      end

      def main_class
        class_names("flex flex-col gap-4 sm:gap-8", {"sm:order-1 sm:col-span-2" => sidebar?})
      end
    end
  end
end

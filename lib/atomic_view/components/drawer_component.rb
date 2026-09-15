# frozen_string_literal: true

module AtomicView
  module Components
    # Drawer
    #
    # A side panel built on the native `<dialog>` element -- same structural
    # trick as `ModalComponent` (see that component for the rationale), just
    # pinned to one edge of the viewport (`side: :left`/`:right`, default
    # `:right`) and stretched to full height instead of centered. `<dialog>`
    # still gets focus-trap, `::backdrop` styling, and Esc-to-close for free;
    # `atomic-view--drawer` (see
    # `app/assets/javascripts/atomic_view/controllers/drawer_controller.js`)
    # layers on `open`/`close` plus closing when the backdrop itself (not the
    # content box) is clicked -- identical to Modal's controller.
    #
    # Layout is a fixed header (title, an optional `actions` slot for e.g. a
    # secondary action button, and an always-present close button) and an
    # optional fixed footer (`renders_one :footer`, typically Cancel/Confirm
    # buttons) around a body that scrolls independently -- the body is the
    # component's default slot (the block passed to `render`).
    #
    # A footer Confirm button that needs to submit a `form_with` in the body
    # can't be nested inside it -- they're siblings, in separate header/
    # body/footer containers. Give the form an explicit `id:` instead, and
    # point the button at it with HTML5's `form="..."` attribute, which
    # associates a button with a form by id no matter where in the DOM the
    # button actually lives:
    #
    #   render(DrawerComponent.new(id: "product-drawer", title: "Add a product")) do |drawer|
    #     drawer.with_footer do
    #       render ButtonComponent.new(nil, "Add product", {type: "submit", form: "product-drawer-form"})
    #     end
    #
    #     form_with(model: @product, id: "product-drawer-form") { |form| ... }
    #   end
    #
    # == Turbo Streams: same content, opened two different ways
    #
    # A drawer's body is often "a page" -- e.g. a New Product form -- that
    # should also work as an ordinary full-page route for a direct link,
    # bookmark, or reload. Both cases render the exact same
    # `DrawerComponent.new(id: "...", open: true) { ... }` call; the
    # difference is only what's *around* it:
    #
    #   * Direct visit (e.g. GET /products/new): render the underlying page
    #     (the product list) as normal, with this drawer -- `open: true` --
    #     included in that same response, already showing on top of it.
    #   * Opened from elsewhere via Turbo Streams: the triggering link/form
    #     targets `format: :turbo_stream`, and the response replaces or
    #     updates a container already sitting on the page with a fresh
    #     render of this same component (again `open: true`):
    #
    #       <%= turbo_stream.update("product-drawer", render(
    #             AtomicView::Components::DrawerComponent.new(id: "product-drawer-dialog", open: true, title: "Add a product") do
    #               render "products/form"
    #             end
    #           )) %>
    #
    # Either way, Turbo inserts a brand new `<dialog>` node, so
    # `atomic-view--drawer` never needs a bespoke "please open now" event to
    # bridge the two cases -- `connect()` sees `open: true` and calls
    # `showModal()` itself every time, whether that's on first paint or after
    # a Turbo Stream swap. Closing it (backdrop click, Esc, or a Cancel
    # button) is just `dialog.close()` -- the page behind it, already in the
    # same document, is simply what's left after the drawer's gone; give the
    # host app's own controller the job of updating the URL back if that
    # matters.
    class DrawerComponent < AtomicView::Component
      renders_one :actions
      renders_one :footer

      attr_reader :id, :title, :side, :open

      def initialize(id:, title: nil, side: :right, open: false, **options)
        super()
        @id = id
        @title = title
        @side = side
        @open = open
        @options = options
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names(
          # `hidden`/`open:flex` (not a bare `flex`) -- the dialog needs
          # `display:flex` once shown (for the header/body/footer column
          # layout), but a bare `flex` utility class is author-origin CSS
          # that would permanently beat the user-agent stylesheet's
          # `dialog:not([open]) { display: none }`, leaving the "closed"
          # dialog fully rendered (and eating clicks) at all times. The
          # `open:` variant (targeting the `[open]` attribute the browser
          # itself adds/removes on showModal()/close()) keeps it hidden
          # until actually shown, same as Modal gets for free by not
          # setting `display` at all.
          "m-0 hidden h-dvh max-h-none w-full flex-col bg-surface p-0 text-foreground shadow-panel open:flex backdrop:bg-backdrop sm:max-w-lg",
          side_classes,
          @options[:class]
        )
      end

      def data_attributes
        attributes = (@options[:data] || {}).merge(controller: "atomic-view--drawer")
        attributes["atomic-view--drawer-open-value"] = true if open
        attributes
      end

      def close_icon
        icon("x-mark", variant: :mini, options: {class: "size-5"}).to_s.html_safe
      end

      private

      def side_classes
        (side == :left) ? "inset-y-0 left-0 right-auto" : "inset-y-0 right-0 left-auto"
      end
    end
  end
end

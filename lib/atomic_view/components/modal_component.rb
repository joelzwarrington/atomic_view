# frozen_string_literal: true

module AtomicView
  module Components
    # Modal
    #
    # A confirmation dialog / modal built on the native `<dialog>` element,
    # wired to `atomic-view--modal` (see
    # `app/assets/javascripts/atomic_view/controllers/modal_controller.js`).
    # Using `<dialog>` gets focus-trap, `::backdrop` styling, and Esc-to-close
    # for free -- the controller only adds `open`/`close`, plus closing when
    # the backdrop itself (not the content box) is clicked.
    #
    # Body content is the component's default slot (the block passed to
    # `render`). The footer -- typically a Cancel/Confirm button pair -- is a
    # `renders_one :footer` slot, since ViewComponent's slot API is the
    # simplest correct way to give this component two independent content
    # areas without inventing a bespoke keyword-based content API.
    #
    # Opening the dialog is the host app's concern: either call
    # `document.getElementById("<id>").showModal()` directly, or wire a
    # trigger element with `data-action="click->atomic-view--modal#open"`
    # (Stimulus resolves the action against the nearest matching controller,
    # which works from inside the dialog's own footer, e.g. a "Cancel"
    # button using `#close`, but not from an unrelated part of the page --
    # see the preview for both patterns).
    class ModalComponent < AtomicView::Component
      renders_one :footer

      attr_reader :id, :title, :danger

      def initialize(id:, title: nil, danger: false, **options)
        super()
        @id = id
        @title = title
        @danger = danger
        @options = options
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names("m-auto bg-surface text-foreground rounded-card shadow-panel p-0 backdrop:bg-backdrop", @options[:class])
      end

      def data_attributes
        (@options[:data] || {}).merge(controller: "atomic-view--modal")
      end

      def danger_icon
        icon("exclamation-triangle", options: {class: "size-6 text-error"}).to_s.html_safe
      end
    end
  end
end

# frozen_string_literal: true

module AtomicView
  module Components
    # Filters
    #
    # The layout/boilerplate for an index page's filter bar: one
    # auto-submitting `form_with`, three fixed slots (`with_chip`,
    # `with_search`, `with_filter`), each always rendered in the same spot
    # rather than a freeform block callers arrange by hand.
    #
    #   <%= render(AtomicView::Components::FiltersComponent.new(url: rentals_path(format: :turbo_stream), preserve: {view: params[:view]})) do |filters| %>
    #     <% filters.with_chip do %>
    #       <% status_options.each do |status| %>
    #         <%= render(AtomicView::Components::ChipComponent.new(name: "status", value: status.value, selected: params[:status] == status.value)) { status.label } %>
    #       <% end %>
    #     <% end %>
    #
    #     <% filters.with_search do |form| %>
    #       <%= form.search_field :q, value: params[:q], placeholder: "Search by camper..." %>
    #     <% end %>
    #
    #     <% filters.with_filter do |form| %>
    #       <%= form.collection_select(:park_id, Park.all, :id, :name, include_blank: "All parks", selected: params[:park_id]) %>
    #     <% end %>
    #   <% end %>
    #
    # - `with_chip` (repeatable) -- content-only, one full-width row per
    #   call, above everything else, in declaration order. Each call
    #   represents one logical group of options (e.g. "status") -- the
    #   caller loops and renders one selectable `ChipComponent` per option
    #   inside it; a second, independent chip group is just a second
    #   `with_chip` call.
    # - `with_search` (single) -- yields the shared form builder; fixed
    #   spot at the start of the second row, given more width than each
    #   `with_filter`.
    # - `with_filter` (repeatable) -- yields the same form builder; renders
    #   after search, sharing the remaining width equally.
    #
    # The yielded "form" in `with_search`/`with_filter` isn't literally the
    # `ActionView::Helpers::FormBuilder` -- it's a thin slot wrapper that
    # delegates every method to the real form builder once FiltersComponent
    # builds it (`form_with` doesn't exist yet when these blocks are
    # captured), so `form.search_field`/`form.select`/`form.collection_select`
    # all work exactly as if it were the real builder.
    #
    # Auto-submit is wired once on the `<form>` itself (`atomic-view--auto-submit`,
    # listening for bubbled `input`/`change`), not per-field -- any native
    # form control dropped into any slot, including a `ChipComponent` radio
    # in `with_chip`, submits on change with no extra wiring.
    #
    # `preserve:` renders one hidden field per key/value, for page state
    # that isn't itself a filter but must ride along on every submit (e.g.
    # a `view:` toggle owned by a different control entirely).
    class FiltersComponent < AtomicView::Component
      # A stand-in for the real form builder, yielded into `with_search`/
      # `with_filter` blocks before the real builder exists. FiltersComponent
      # assigns the real builder onto every instance of this once `form_with`
      # actually yields it -- see `#assign_form`.
      class FieldSlot < AtomicView::Component
        attr_accessor :form

        def call
          content
        end

        def method_missing(name, ...)
          return form.public_send(name, ...) if form.respond_to?(name)
          super
        end

        def respond_to_missing?(name, include_private = false)
          form.respond_to?(name) || super
        end

        # ViewComponent::Base already includes ActionView's generic,
        # object-argument Form(Options)Helper methods for template
        # rendering -- e.g. a bare `select(object, method, choices, ...)`,
        # not FormBuilder's per-attribute `form.select(method, choices,
        # ...)`. Those real, inherited methods share names with the form
        # builder's and would otherwise win over method_missing entirely,
        # getting called with the wrong arity/meaning. Undefining every
        # name the real form builder responds to forces all of them
        # through method_missing above instead.
        (AtomicView::FormBuilder.instance_methods - Object.instance_methods).each do |name|
          undef_method(name) if method_defined?(name)
        end
      end

      renders_many :chips
      renders_one :search, FieldSlot
      renders_many :filters, FieldSlot

      attr_reader :url, :method, :preserve

      def initialize(url:, method: :get, preserve: {}, **options)
        super()
        @url = url
        @method = method
        @preserve = preserve
        @options = options
      end

      def html_class
        class_names("flex flex-col gap-3 w-full", @options[:class])
      end

      def html_options
        @options.except(:class, :data)
      end

      def data_attributes
        (@options[:data] || {}).merge(
          controller: "atomic-view--auto-submit",
          action: "input->atomic-view--auto-submit#submit change->atomic-view--auto-submit#submit"
        )
      end

      # Called from the template once `form_with` actually yields the real
      # builder -- pushes it onto every FieldSlot instance so `with_search`/
      # `with_filter`'s already-captured blocks can delegate to it.
      def assign_form(form)
        search.form = form if search?
        filters.each { |filter| filter.form = form }
      end

      def row?
        search? || filters.any?
      end
    end
  end
end

# frozen_string_literal: true

module AtomicView
  module Components
    # CommandPalette
    #
    # A `Cmd/Ctrl+K` search dialog built on the native `<dialog>` element
    # (same structural trick as `ModalComponent` -- see that component for
    # the rationale -- but wired to its own `atomic-view--command-palette`
    # controller rather than sharing Modal's, so the two stay independently
    # simple with no inter-component dependency). `<dialog>` gets
    # focus-trap, `::backdrop` styling, and Esc-to-close for free; the
    # controller layers on the global open shortcut, client-side
    # filter-as-you-type, and arrow-key navigation.
    #
    # Results are supplied as plain data rather than slots:
    #
    #   sections: [
    #     { label: "Pages", results: [
    #       { label: "Dashboard", href: "/dashboard", hint: "G D" },
    #       { label: "Settings", href: "/settings" }
    #     ] }
    #   ]
    #
    # `SegmentedControlComponent` and `PaginationComponent` already use this
    # array-of-hashes shape for link collections, and it's the better fit
    # here (over slots, `DropdownComponent`'s approach) as the *default*
    # entry point: every row needs the same two JS hooks -- a
    # `[data-atomic-view--command-palette-target="row"]` marker and a
    # `data-search-text` attribute -- generated consistently so the
    # filter/keyboard-nav controller can rely on them, which a free-form
    # slot would push onto every consumer to wire up by hand. The component
    # stays agnostic about what a result *links to* (any `href` works -- a
    # path, an external URL, a `turbo_frame`-aware route, etc.), which is
    # the same kind of agnosticism `DropdownComponent` keeps about its menu
    # content, just expressed as data instead of markup.
    #
    # Under the hood, `sections:`/`results:` are sugar over real
    # `SectionComponent`/`RowComponent` slots -- `with_section`/`with_row`
    # accept the same keyword shape:
    #
    #   render(CommandPaletteComponent.new(id: "x")) do |palette|
    #     palette.with_section(label: "Campers") do |section|
    #       section.with_row(label: "Joel", href: "/campers/1")
    #     end
    #   end
    #
    # Because they're real components, `SectionComponent` and `RowComponent`
    # are independently renderable outside the dialog -- e.g. from a Turbo
    # Stream response that re-renders `results_id` while server-side
    # filtering, without forking this markup. See those classes' docs.
    #
    # `result[:hint]`, when given, renders as a `<kbd>` -- e.g. a keyboard
    # shortcut like "G D" -- next to the result label.
    #
    # `footer` is a slot for a bottom hint bar documenting shortcuts/facets
    # (e.g. "Type # to access projects") -- free-form content, since it's
    # typically a sentence with `KbdComponent`s mixed in rather than
    # structured data.
    class CommandPaletteComponent < AtomicView::Component
      renders_one :footer
      renders_many :sections, "AtomicView::Components::CommandPaletteComponent::SectionComponent"

      attr_reader :id, :placeholder

      def self.results_id(id)
        "#{id}-results"
      end

      def initialize(id:, sections: [], placeholder: "Search...", input_data: {}, **options)
        super()
        @id = id
        @placeholder = placeholder
        @input_data = input_data
        @options = options
        sections.each { |section| with_section(**section) }
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names("mx-auto mt-[15vh] w-full max-w-lg overflow-hidden rounded-card bg-surface p-0 text-foreground shadow-panel backdrop:bg-backdrop", @options[:class])
      end

      def results_id
        self.class.results_id(id)
      end

      def data_attributes
        controllers = ["atomic-view--command-palette", @options.dig(:data, :controller)].compact.join(" ")
        (@options[:data] || {}).except(:controller).merge(controller: controllers)
      end

      def input_data_attributes
        actions = ["input->atomic-view--command-palette#filter", "keydown->atomic-view--command-palette#navigate", @input_data[:action]].compact.join(" ")
        {"atomic-view--command-palette-target" => "input", **@input_data.except(:action), "action" => actions}
      end
    end
  end
end

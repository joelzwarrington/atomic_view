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
    # here (over slots, `DropdownComponent`'s approach): every row needs the
    # same two JS hooks -- a `[data-atomic-view--command-palette-target="row"]`
    # marker and a `data-search-text` attribute -- generated consistently so
    # the filter/keyboard-nav controller can rely on them, which a
    # free-form slot would push onto every consumer to wire up by hand. The
    # component stays agnostic about what a result *links to* (any `href`
    # works -- a path, an external URL, a `turbo_frame`-aware route, etc.),
    # which is the same kind of agnosticism `DropdownComponent` keeps about
    # its menu content, just expressed as data instead of markup.
    #
    # `result[:hint]`, when given, renders as a `<kbd>` -- e.g. a keyboard
    # shortcut like "G D" -- next to the result label.
    class CommandPaletteComponent < AtomicView::Component
      attr_reader :id, :placeholder, :sections

      def initialize(id:, sections: [], placeholder: "Search...", **options)
        super()
        @id = id
        @sections = sections
        @placeholder = placeholder
        @options = options
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names("w-full max-w-lg rounded-card bg-surface p-0 text-foreground shadow-panel backdrop:bg-backdrop", @options[:class])
      end

      def data_attributes
        (@options[:data] || {}).merge(controller: "atomic-view--command-palette")
      end

      def input_data_attributes
        {
          "atomic-view--command-palette-target" => "input",
          :action => "input->atomic-view--command-palette#filter keydown->atomic-view--command-palette#navigate"
        }
      end

      def row_data_attributes(result)
        {
          "atomic-view--command-palette-target" => "row",
          :search_text => search_text_for(result)
        }
      end

      def search_text_for(result)
        (result[:search_text] || result[:label]).to_s.downcase
      end
    end
  end
end

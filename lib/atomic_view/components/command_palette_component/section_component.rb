# frozen_string_literal: true

module AtomicView
  module Components
    class CommandPaletteComponent
      # A labeled group of `RowComponent` results within a CommandPalette.
      # Rendered via `CommandPaletteComponent#with_section`, or standalone
      # (e.g. from a Turbo Stream response updating `results_id`) -- see
      # `CommandPaletteComponent`'s class docs.
      class SectionComponent < AtomicView::Component
        renders_many :rows, "AtomicView::Components::CommandPaletteComponent::RowComponent"

        attr_reader :label

        def initialize(label:, results: [], **options)
          super()
          @label = label
          @options = options
          results.each { |result| with_row(**result) }
        end
      end
    end
  end
end

# frozen_string_literal: true

module AtomicView
  module Components
    class CommandPaletteComponent
      # A single CommandPalette result: a link carrying the JS hooks --
      # `[data-atomic-view--command-palette-target="row"]` and
      # `data-search-text` -- the filter/keyboard-nav controller relies on.
      # Rendered via `CommandPaletteComponent#with_section`'s `results:`
      # sugar, or `SectionComponent#with_row` directly -- see
      # `CommandPaletteComponent`'s class docs.
      #
      # `icon:`, when given, renders a Heroicon before the label -- same
      # `icon:` convention as `NavigationTreeComponent::ItemComponent`.
      class RowComponent < AtomicView::Component
        attr_reader :label, :href, :hint, :icon_name

        def initialize(label:, href: "#", hint: nil, search_text: nil, icon: nil, **options)
          super()
          @label = label
          @href = href
          @hint = hint
          @search_text = search_text
          @icon_name = icon
          @options = options
        end

        def data_attributes
          (@options[:data] || {}).merge(
            "atomic-view--command-palette-target" => "row",
            "search_text" => (@search_text || label).to_s.downcase
          )
        end
      end
    end
  end
end

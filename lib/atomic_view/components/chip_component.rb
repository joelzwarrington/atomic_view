# frozen_string_literal: true

module AtomicView
  module Components
    # Chip
    #
    # A dismissible chip is automatically wired to `atomic-view--chip`, the
    # Stimulus controller that handles removing it from the DOM on click
    # (see `app/assets/javascripts/atomic_view/controllers/chip_controller.js`).
    # Pass `dismiss_button_options` only to customize that behavior, e.g. to
    # trigger a network request instead of (or in addition to) the default
    # remove animation.
    #
    # A chip can also be *selectable* rather than dismissible -- for a row
    # of filter options (e.g. status: All/Active/Completed) rendered as
    # individual pills rather than a joined SegmentedControlComponent
    # track. Two selectable modes, matching SegmentedControlComponent's own
    # link/radio split:
    #
    # - `href:` renders an `<a>` -- plain navigation, for a page not inside
    #   an auto-submitting form. `selected:` drives the active styling.
    # - `name:` (+ `value:`, `selected:`) renders a real
    #   `<input type="radio"> + <label>` pair, styled identically, so it
    #   participates in a real form submission -- e.g. dropped straight
    #   into FiltersComponent's `with_chip`, where the radio's native
    #   `change` event bubbles to the form's auto-submit action with no
    #   extra wiring.
    #
    # `dismissible:` only applies to the plain (non-selectable) mode -- a
    # filter pill is "unselected" by picking a different one, not by its
    # own close button.
    #
    # The selected treatment is additive (`ring-2 ring-current`), not a
    # bg/text override -- a caller coloring different values differently
    # (e.g. a status chip carrying `class: "text-success"`) keeps that
    # color when selected, with `ring-current` picking it up automatically
    # for the emphasis ring, rather than every selected chip flattening to
    # the same neutral look regardless of its own color.
    class ChipComponent < AtomicView::Component
      attr_reader :dismissible, :dismiss_button_options, :leading, :href, :name, :value, :selected

      def initialize(dismissible: false, dismiss_button_options: {}, leading: nil, href: nil, name: nil, value: nil, selected: false, **options)
        super()
        @dismissible = dismissible
        @dismiss_button_options = dismiss_button_options
        @leading = leading
        @href = href
        @name = name
        @value = value
        @selected = selected
        @options = options
      end

      def call
        return radio_chip if name.present?
        return link_chip if href.present?

        span_chip
      end

      private

      def span_chip
        tag.span(**@options.except(:class, :data), class: class_names(base_classes, @options[:class]), data: data_attributes) do
          safe_join([leading, content, dismiss_button].compact)
        end
      end

      def link_chip
        link_to(href, **@options.except(:class), class: class_names(base_classes, selected_classes, @options[:class]), aria: {current: (selected ? "true" : nil)}) do
          safe_join([leading, content].compact)
        end
      end

      # Wrapped in a `display: contents` span -- Tailwind's `peer-checked:`
      # relies on the CSS general sibling combinator (`~`), which matches
      # *every* later sibling under the same parent once a peer is
      # checked, not just the one meant to pair with it. Rendered as flat
      # siblings (as `with_chip`'s multiple chips are), checking any one
      # radio would light up every chip after it. This span isolates each
      # input/label pair's sibling relationship to just the two of them --
      # `display: contents` keeps it invisible to layout, same technique
      # SegmentedControlComponent's own radio mode already uses.
      def radio_chip
        tag.span(class: "contents") do
          safe_join([
            tag.input(**@options.except(:class, :id), type: "radio", name: name, value: value, id: radio_id, checked: selected, class: "peer sr-only"),
            tag.label(safe_join([leading, content].compact), for: radio_id, class: class_names(base_classes, "cursor-pointer peer-checked:ring-2 peer-checked:ring-current peer-checked:font-semibold", @options[:class]))
          ])
        end
      end

      def radio_id
        "#{name}_#{value}"
      end

      def selected_classes
        "ring-2 ring-current font-semibold" if selected
      end

      def base_classes
        "inline-flex items-center gap-1 rounded-btn bg-offset px-2 py-0.5 text-xs font-medium text-foreground border border-border"
      end

      def data_attributes
        attributes = (@options[:data] || {}).dup
        return attributes unless dismissible

        attributes[:controller] = [attributes[:controller], "atomic-view--chip"].compact.join(" ")
        attributes
      end

      def dismiss_button
        return unless dismissible

        options = dismiss_button_options.except(:class, :data)
        data = {action: "click->atomic-view--chip#remove"}.merge(dismiss_button_options[:data] || {})

        tag.button(**options, type: "button", data: data, class: class_names("inline-flex items-center", dismiss_button_options[:class])) do
          icon("x-mark", variant: :mini, options: {class: "size-3.5"}).to_s.html_safe
        end
      end
    end
  end
end

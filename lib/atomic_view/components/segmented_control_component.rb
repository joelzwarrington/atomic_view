# frozen_string_literal: true

module AtomicView
  module Components
    # SegmentedControl
    #
    # Renders a "pill track" of mutually-exclusive segments. Which of two
    # modes is used is inferred from the shape of `options`:
    #
    # - Link mode: options are {label:, href:} hashes, rendered as <a> tags.
    #   Meant for plain filter tabs where the "selected" state is just the
    #   current request's query string, not a form value (e.g. tabs above a
    #   table driven by `?filter=`). `selected` is compared against each
    #   option's `label:` rather than its `href:` -- the consumer already
    #   has the current filter's display value in hand (e.g.
    #   `params[:filter]`), so matching on `label:` avoids making every
    #   caller build a comparable canonical href just to find the active
    #   tab.
    #
    # - Radio mode: options are {label:, value:} hashes, rendered as native
    #   <input type="radio"> + <label> pairs so the control can participate
    #   in a real form submission. `name:` is required in this mode and
    #   becomes every radio's `name` attribute. `selected` is compared
    #   against each option's `value:`. The checked state is styled purely
    #   with CSS: each radio gets a `peer` marker class (hidden via
    #   `sr-only`) and its label uses `peer-checked:` utilities -- the same
    #   technique `check_box_component.rb` and `radio_button_component.rb`
    #   use for their checked states, just applied to a sibling label
    #   instead of the input itself, since the checked state lives on the
    #   input.
    #
    # Both modes share the same visual: an inline-flex, rounded, muted
    # track (`bg-offset`) with the active/checked segment raised via
    # `bg-surface` + `shadow-sm`.
    class SegmentedControlComponent < AtomicView::Component
      attr_reader :options, :selected, :name

      def initialize(options:, selected:, name: nil, **html_options)
        super()
        @options = options
        @selected = selected
        @name = name
        @html_options = html_options
      end

      def link_mode?
        options.first&.key?(:href)
      end

      def active?(option)
        link_mode? ? (option[:label] == selected) : (option[:value] == selected)
      end

      def track_class
        class_names("inline-flex items-center gap-1 rounded-btn bg-offset p-1", @html_options[:class])
      end

      def link_attributes(option)
        attributes = {class: segment_classes(option)}
        attributes[:"aria-current"] = "true" if active?(option)
        attributes
      end

      def radio_id(option)
        "#{name}_#{option[:value]}"
      end

      def radio_attributes(option)
        {
          type: "radio",
          name: name,
          value: option[:value],
          id: radio_id(option),
          checked: active?(option),
          class: "peer sr-only"
        }
      end

      def label_classes(_option)
        class_names(segment_base_classes, "cursor-pointer peer-checked:bg-surface peer-checked:text-foreground peer-checked:shadow-sm", inactive_classes)
      end

      private

      def segment_classes(option)
        class_names(segment_base_classes, active?(option) ? active_classes : inactive_classes)
      end

      def segment_base_classes
        "rounded-btn px-2.5 py-1 text-sm font-medium transition-colors"
      end

      def active_classes
        "bg-surface text-foreground shadow-sm"
      end

      def inactive_classes
        "text-muted-foreground"
      end
    end
  end
end

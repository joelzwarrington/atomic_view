# frozen_string_literal: true

module AtomicView
  module Components
    # Tooltip
    #
    # A trigger plus a floating label, positioned by `@floating-ui/dom` and
    # wired to `atomic-view--tooltip` (see
    # `app/assets/javascripts/atomic_view/controllers/tooltip_controller.js`).
    # The controller shows the tooltip on hover/focus of the trigger and
    # hides it on mouseleave/blur/Esc, keeping it anchored to the trigger
    # while the page scrolls or resizes.
    #
    # The bubble uses `strategy: "fixed"` (and a `fixed` class, not
    # `absolute`) rather than `DropdownComponent`'s approach -- an
    # absolutely-positioned bubble's containing block is the trigger's own
    # `relative` wrapper span, so its shrink-to-fit width silently caps out
    # at the *trigger's* rendered width no matter how generous `max-w-*` is.
    # `fixed` makes the viewport the containing block instead, so
    # `content_class` (below) actually controls the bubble's width.
    #
    # Pass `text:` for the common case of a short plain-text label:
    #
    #   render(TooltipComponent.new(text: "Delete")) do |tooltip|
    #     tooltip.with_trigger { icon_button }
    #   end
    #
    # or a `body` slot for anything richer than plain text.
    #
    # The bubble defaults to `max-w-xs` (20rem) -- wide enough for a short
    # label or two lines of `body` content. Pass `content_class:` to widen
    # (or otherwise restyle) it for longer text:
    #
    #   render(TooltipComponent.new(text: "...", content_class: "max-w-sm"))
    #
    # It's a separate option from `class:`, which targets the outer trigger
    # wrapper -- `content_class:` is merged (via TailwindMerge) onto the
    # floating bubble itself, so `max-w-sm` here replaces the default
    # `max-w-xs` rather than fighting it.
    class TooltipComponent < AtomicView::Component
      renders_one :trigger
      renders_one :body

      PLACEMENTS = %w[top bottom left right].freeze

      attr_reader :text, :placement

      def initialize(text: nil, placement: "top", content_class: nil, **options)
        super()
        @text = text
        @placement = PLACEMENTS.include?(placement) ? placement : "top"
        @id = "tooltip-#{SecureRandom.hex(4)}"
        @content_class = content_class
        @options = options
      end

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names("relative inline-block", @options[:class])
      end

      def data_attributes
        (@options[:data] || {}).merge(
          :controller => "atomic-view--tooltip",
          "atomic-view--tooltip-placement-value" => placement
        )
      end

      def trigger_data_attributes
        {
          "atomic-view--tooltip-target" => "trigger",
          :action => "mouseenter->atomic-view--tooltip#show mouseleave->atomic-view--tooltip#hide " \
            "focusin->atomic-view--tooltip#show focusout->atomic-view--tooltip#hide"
        }
      end

      def content_id
        @id
      end

      def content_data_attributes
        {"atomic-view--tooltip-target" => "content"}
      end

      def content_class
        class_names(
          "pointer-events-none hidden fixed z-50 max-w-xs rounded-well bg-foreground px-2 py-1 text-xs " \
            "font-medium text-surface shadow-soft",
          @content_class
        )
      end
    end
  end
end

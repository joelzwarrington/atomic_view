# frozen_string_literal: true

module AtomicView
  module Components
    # Card
    #
    # A generic surface container for grouping related content. `default` is
    # a plain bordered panel; `destructive` is the same shape with a tinted
    # red border/background, for a "danger zone" section (e.g. an archive or
    # delete action with its consequences explained) -- the same
    # `border-destructive bg-destructive/10` treatment AlertComponent already
    # uses for its own error variant. The variant only colors the card
    # itself; any heading/button inside it is the caller's own content.
    #
    # Pass plain content for a single padded panel. For a settings-list style
    # card -- several rows, each with its own label/action, a divider
    # between them but not around the outside -- use `with_section` instead:
    #
    #   render(AtomicView::Components::CardComponent.new(variant: :destructive)) do |card|
    #     card.with_section do
    #       tag.div(class: "flex items-center justify-between gap-4") do
    #         tag.div { tag.p("Archive this rental", class: "font-medium") + tag.p("...", class: "text-sm text-muted-foreground") } +
    #           render(LinkComponent.new("#", variant: :muted)) { "Archive" }
    #       end
    #     end
    #
    #     card.with_section { ... }
    #   end
    #
    # Each section gets the card's own padding (rather than the card as a
    # whole), and a `divide-y` on the section container adds a border
    # between consecutive sections automatically -- there's no first/last
    # index to track, Tailwind's `divide-y` only ever borders the boundary
    # between two siblings. A card with no sections given renders exactly as
    # before -- `with_section` is opt-in, not a second required API.
    class CardComponent < AtomicView::Component
      PADDING_CLASSES = "p-2.5 px-4"

      renders_many :sections, "SectionComponent"

      attr_reader :hoverable, :variant

      def initialize(variant: :default, hoverable: false, **options)
        super()
        @variant = variant
        @hoverable = hoverable
        @options = options
      end

      def sectioned?
        sections.any?
      end

      def html_class
        class_names(base_classes, variant_classes, hoverable_classes, padding_class, @options[:class])
      end

      # The divider color between sections is tied to the variant rather
      # than a flat `divide-border` -- a neutral gray divider reads fine on
      # the plain surface background, but loses almost all contrast against
      # a tinted `bg-destructive/10` panel in light mode.
      def divider_class
        class_names("divide-y", (variant == :destructive) ? "divide-destructive/30" : "divide-border")
      end

      private

      def base_classes
        "bg-surface rounded-card border"
      end

      def padding_class
        PADDING_CLASSES unless sectioned?
      end

      def variant_classes
        case variant
        when :destructive
          "border-destructive bg-destructive/10"
        else
          "border-border"
        end
      end

      def hoverable_classes
        "hover:shadow-soft transition-shadow" if hoverable
      end
    end
  end
end

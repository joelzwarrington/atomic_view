# frozen_string_literal: true

module AtomicView
  module Components
    # Timeline
    #
    # A vertical audit/activity feed -- e.g. a record's created/changed/
    # commented history. Items are supplied as plain data rather than
    # slots, the same call `CommandPaletteComponent` makes for its result
    # rows: every item needs the same marker + meta-line + connecting-line
    # layout generated consistently, which a free-form slot would push
    # onto every consumer to reassemble by hand.
    #
    #   items: [
    #     { icon: "flag", actor: "Karen Will", description: "created this park", time: "Jan 12, 2024" },
    #     { avatar: "KW", actor: "Karen Will", description: "commented", time: "3h ago",
    #       content: tag.div("Following up...", class: "mt-2 rounded-btn bg-offset p-2 text-sm") }
    #   ]
    #
    # Each item needs exactly one marker: `icon:` (a Heroicon name, shown in
    # a plain circular badge) or `avatar:` (initials, rendered via
    # `AvatarComponent`) -- for a system event vs. something a person did.
    # `actor:` is optional bold text before `description:` (omit it for
    # system-generated events, e.g. "Status changed automatically").
    # `content:` is optional free-form HTML-safe markup below the meta
    # line -- a diff comparison, a badge change, a comment bubble -- since
    # that part varies too much to model as data.
    class TimelineComponent < AtomicView::Component
      attr_reader :items

      def initialize(items:, **options)
        super()
        @items = items
        @options = options
      end

      def container_class
        class_names("flex flex-col", @options[:class])
      end

      def item_class(index)
        class_names("relative flex gap-3.5", "pb-6" => !last?(index))
      end

      def render_line?(index)
        !last?(index)
      end

      def marker(item)
        if item[:avatar].present?
          render(AvatarComponent.new(initials: item[:avatar], class: "size-7 shrink-0 text-xs"))
        else
          tag.span(class: "flex size-7 shrink-0 items-center justify-center rounded-full bg-muted text-muted-foreground") do
            icon(item[:icon], options: {class: "size-3.5"}).to_s.html_safe
          end
        end
      end

      def meta(item)
        parts = []
        parts << tag.strong(item[:actor], class: "font-semibold") if item[:actor].present?
        parts << item[:description]
        safe_join(parts, " ")
      end

      private

      def last?(index)
        index == items.length - 1
      end
    end
  end
end

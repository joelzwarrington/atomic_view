# frozen_string_literal: true

module AtomicView
  module Components
    # Timeline
    #
    # A vertical audit/activity feed -- e.g. a record's created/changed/
    # commented history. Each row is a `with_item` slot rather than a plain
    # data hash: every item needs the same marker + meta-line + connecting-
    # line layout generated consistently, and slots let each item take
    # strongly-typed keyword arguments (with real defaults) plus optional
    # free-form block content, instead of a loose symbol-keyed hash.
    #
    #   render(TimelineComponent.new) do |timeline|
    #     timeline.with_item(icon: "flag", actor: "Karen Will", description: "created this park", time: 1.year.ago)
    #
    #     timeline.with_item(avatar: "KW", actor: "Karen Will", description: "commented", time: 3.hours.ago) do
    #       tag.div("Following up...", class: "mt-2 rounded-btn bg-offset p-2 text-sm")
    #     end
    #   end
    #
    # Each item needs exactly one marker: `icon:` (a Heroicon name, shown in
    # a plain circular badge) or `avatar:` (initials, rendered via
    # `AvatarComponent`) -- for a system event vs. something a person did.
    # `actor:` is optional bold text before `description:` (omit it for
    # system-generated events, e.g. "Status changed automatically"). `time:`
    # takes a real `Time`/`Date`/`DateTime`/`ActiveSupport::TimeWithZone`
    # rather than a preformatted string -- see `ItemComponent`'s class docs
    # for how it's rendered. The block passed to `with_item` is optional
    # free-form HTML-safe content below the meta line -- a diff comparison,
    # a badge change, a comment bubble -- since that part varies too much
    # to model as a keyword argument. See `ItemComponent` for the per-item
    # API.
    class TimelineComponent < AtomicView::Component
      renders_many :items, "ItemComponent"

      def initialize(**options)
        super()
        @options = options
      end

      def container_class
        class_names("flex flex-col", @options[:class])
      end

      def item_wrapper_class(index)
        class_names("relative flex gap-3.5", "pb-6" => !last?(index))
      end

      def render_line?(index)
        !last?(index)
      end

      private

      def last?(index)
        index == items.length - 1
      end
    end
  end
end

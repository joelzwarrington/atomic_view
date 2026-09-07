# frozen_string_literal: true

module AtomicView
  module Components
    class TimelineComponent
      # A single Timeline row: a marker (icon or avatar) plus a meta line
      # (optional actor + description + time) and optional free-form block
      # content. Rendered via `TimelineComponent#with_item` -- see
      # `TimelineComponent`'s class docs.
      #
      # `time:` takes a real `Time`/`Date`/`DateTime`/
      # `ActiveSupport::TimeWithZone` -- not a preformatted string -- and is
      # rendered with the `local_time` gem's `local_time_ago` helper (see
      # `AtomicView::Component`), which degrades gracefully to an absolute
      # UTC timestamp server-side and upgrades to a relative "3 hours ago"
      # (aging into a full date over time) client-side once the host app
      # loads local_time's JS -- see `config/importmap.rb`'s "local-time"
      # pin comment for that setup.
      class ItemComponent < AtomicView::Component
        attr_reader :icon_name, :avatar, :actor, :description, :time

        def initialize(description:, icon: nil, avatar: nil, actor: nil, time: nil)
          super()
          @icon_name = icon
          @avatar = avatar
          @actor = actor
          @description = description
          @time = time
        end

        def marker
          if avatar.present?
            render(AvatarComponent.new(initials: avatar, class: "size-7 shrink-0 text-xs"))
          else
            tag.span(class: "flex size-7 shrink-0 items-center justify-center rounded-full bg-muted text-muted-foreground") do
              icon(icon_name, options: {class: "size-3.5"}).to_s.html_safe
            end
          end
        end

        def meta
          parts = []
          parts << tag.strong(actor, class: "font-semibold") if actor.present?
          parts << description
          safe_join(parts, " ")
        end
      end
    end
  end
end

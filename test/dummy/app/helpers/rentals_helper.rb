# frozen_string_literal: true

module RentalsHelper
  # A site's bookings within `starts_on`..`ends_on`, plus the lane each one
  # packs into (see AtomicView::Components::GanttComponent.pack_lanes).
  # Shared between the initial render (`gantt.with_row`, see index.html.erb)
  # and a row-pagination response rendering `RowComponent` standalone (see
  # index.turbo_stream.erb) so both build the exact same row.
  def row_bookings_and_lanes(site, dates)
    bookings = site.bookings_within(dates.first, dates.last)
    lanes = AtomicView::Components::GanttComponent.pack_lanes(bookings.map { |b| [b.starts_on, b.ends_on] })
    [bookings, lanes]
  end

  def row_attrs(site, origin, lanes)
    {
      id: dom_id(site, :row),
      label: site.code,
      sublabel: site.park_name,
      origin: origin,
      today: Date.current,
      lanes: (lanes.max || -1) + 1
    }
  end

  def with_row_items(row, bookings, lanes, origin)
    bookings.zip(lanes).each do |booking, lane|
      row.with_item(
        id: dom_id(booking, :bar),
        starts_on: booking.starts_on,
        ends_on: booking.ends_on,
        origin: origin,
        lane: lane,
        label: booking.camper_name,
        variant: booking.variant
      )
    end
  end
end

# frozen_string_literal: true

# Backs RentalsController, a real ActiveRecord + Turbo Streams demo of
# GanttComponent -- see that controller and its views for the wiring this
# data exercises. Seeds a wide date range (well before and after "today")
# so both directions of horizontal (date) pagination have real data to
# reveal, not just the initial window.

Booking.delete_all
Site.delete_all

origin = Date.current.beginning_of_month
parks = ["Riverside", "Eagle Ridge", "Green Mountain"]
campers = ["Karen Wilson", "Tom Bennett", "Marcus Lee", "R. Nguyen", "S. Okafor", "Devon Clarke", "J. Fontaine",
  "Aisha Rahman", "Priya Anand", "B. Osei", "The Delgado Family", "N. Petrov", "Chris Alvarez", "M. Haddad"]

sites = parks.each_with_index.flat_map do |park, park_index|
  prefix = park.split.map { |w| w[0] }.join
  (1..12).map do |n|
    Site.create!(code: format("%s%03d", prefix, n), park_name: park)
  end
end

sites.each_with_index do |site, index|
  # A handful of sites stay empty ("available all month") -- a real gap in
  # the data, not every row needs a booking.
  next if index % 5 == 4

  booking_count = [0, 1, 1, 2, 2, 3].sample
  booking_count.times do |n|
    starts_on = origin + rand(-40..50)
    ends_on = starts_on + [2, 3, 4, 6, 10, 20, 45].sample

    Booking.create!(
      site: site,
      camper_name: campers.sample,
      starts_on: starts_on,
      ends_on: ends_on,
      status: Booking::STATUSES.sample
    )
  end
end

# RentalsController shows rows in `Site.order(:code, :id)` -- alphabetical by
# code, not creation order -- so a demo-critical booking needs to land on one
# of *those* first few rows to be visible without also scrolling down through
# row pagination first. `sites.first`/`sites.second` (Ruby array order, which
# follows `parks`, Riverside-first) don't match that: single-word park names
# collapse to a one-letter prefix (`"Riverside".split` has nothing to join,
# so its prefix is just "R"), and "ER"/"GM" both alphabetically precede "R".
first_page_sites = Site.order(:code, :id).limit(2)

# Force at least one clearly overlapping pair so the demo's lane-packing
# (GanttComponent.pack_lanes) has something real to pack.
overlap_site = first_page_sites.first
Booking.create!(site: overlap_site, camper_name: "Karen Wilson", starts_on: origin, ends_on: origin + 19, status: "active")
Booking.create!(site: overlap_site, camper_name: "Inquiry · overlaps stay", starts_on: origin + 14, ends_on: origin + 17, status: "pending")

# A booking spanning ~2.5 months, crossing several month boundaries -- lets
# you scroll right through `next_dates_path` and watch the same bar stay
# correctly rendered (and the month band correctly split) as more of it
# comes into view, rather than only ever seeing short bookings that fit
# inside a single loaded page of dates.
long_stay_site = first_page_sites.second
Booking.create!(site: long_stay_site, camper_name: "The Whitfield Family · Seasonal", starts_on: origin + 5, ends_on: origin + 85, status: "active")

puts "Seeded #{Site.count} sites and #{Booking.count} bookings."

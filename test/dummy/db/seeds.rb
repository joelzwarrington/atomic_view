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

# Force at least one clearly overlapping pair so the demo's lane-packing
# (GanttComponent.pack_lanes) has something real to pack.
overlap_site = sites.first
Booking.create!(site: overlap_site, camper_name: "Karen Wilson", starts_on: origin, ends_on: origin + 19, status: "active")
Booking.create!(site: overlap_site, camper_name: "Inquiry · overlaps stay", starts_on: origin + 14, ends_on: origin + 17, status: "pending")

puts "Seeded #{Site.count} sites and #{Booking.count} bookings."

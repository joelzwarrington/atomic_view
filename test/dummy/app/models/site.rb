# frozen_string_literal: true

class Site < ApplicationRecord
  has_many :bookings, dependent: :destroy

  # Bookings intersecting `starts_on`..`ends_on` -- used by RentalsController
  # to decide which of a site's bookings belong in a given render, whether
  # that's the initial page load or a horizontal (date) pagination response.
  # See AtomicView::Components::GanttComponent.overlaps_range?, which this
  # mirrors as a SQL scope instead of an in-memory check.
  def bookings_within(starts_on, ends_on)
    bookings.where("starts_on <= ? AND ends_on >= ?", ends_on, starts_on).order(:starts_on)
  end
end

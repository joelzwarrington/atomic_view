# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :site

  STATUSES = %w[active confirmed completed cancelled pending].freeze
  validates :status, inclusion: {in: STATUSES}

  # Maps this booking's domain status onto GanttComponent::ItemComponent's
  # generic variant tokens -- see that class's docs for why the mapping
  # lives on the consumer's side rather than the component knowing about
  # "confirmed"/"cancelled"/etc. itself.
  VARIANTS_BY_STATUS = {
    "active" => :success,
    "confirmed" => :warning,
    "completed" => :muted,
    "cancelled" => :destructive,
    "pending" => :outline
  }.freeze

  def variant
    VARIANTS_BY_STATUS.fetch(status, :primary)
  end
end

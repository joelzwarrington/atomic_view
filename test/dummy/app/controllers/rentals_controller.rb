# frozen_string_literal: true

# A real ActiveRecord + Turbo Streams demo of GanttComponent -- everything
# GanttComponent's class docs describe in the abstract (Pagy keyset row
# pagination, bidirectional date pagination, lane-packed overlaps) wired up
# against real `Site`/`Booking` records, not pseudocode. Visit /rentals.
#
# == How the two pagination axes stay in sync
#
# `next_dates_path`/`prev_dates_path` need to know which *rows* are
# currently on the page, so their responses can backfill new bars into all
# of them -- not just the first page of sites, if the user has already
# scrolled down and loaded more. This controller tracks that with a plain
# `rows_loaded:` count (how many sites, in the stable `:code, :id` order,
# have been rendered so far) rather than re-deriving Pagy's own keyset
# cursor -- simpler, and sites are already deterministically ordered, so
# "the first N" is exactly "everything loaded via next_rows_path so far".
#
# That count has to stay current on *both* date sentinels even when only
# rows change -- see `index.turbo_stream.erb`, which replaces them with
# updated URLs every time a new page of rows loads, even though no dates
# changed. Skipping that step wouldn't break the very next date-pagination
# request, but the one after it: it would backfill bars into only the rows
# that existed when the *sentinel* was last rendered, silently missing any
# rows loaded in between.
#
# == How "which dates are new" is decided -- and why there's no dedup
#
# `after:`/`before:` is the one date already at the edge of what's loaded
# (`@dates.last`/`@dates.first`). The next/previous batch is computed as
# everything strictly beyond it -- `after + 1`..`after + DATE_BATCH`, or
# the mirror image going backward (see `#dates`). Because each batch is
# defined *relative to what was just rendered* rather than an absolute
# offset the client tracks separately, there's no way for the same date to
# be requested twice, so nothing needs to deduplicate the result -- neither
# this controller nor the `atomic-view--gantt` Stimulus controller does.
class RentalsController < ApplicationController
  include Pagy::Method

  ROW_LIMIT = 8
  DATE_WINDOW = 21
  DATE_BATCH = 14
  MIN_DATE = 120.days.ago.to_date

  def index
    @origin = parse_date(params[:origin]) || Date.current.beginning_of_month
    @dates = (@origin...(@origin + DATE_WINDOW)).to_a
    @pagy, @sites = pagy(:keyset, Site.order(:code, :id), limit: ROW_LIMIT)
    @rows_loaded = @sites.size

    respond_to do |format|
      format.html
      format.turbo_stream # only reached by the row_pagination frame's lazy src
    end
  end

  # GET /rentals/dates -- exactly one of `after:`/`before:` is given, never
  # both; see the class docs above for what each does.
  def dates
    @origin = parse_date(params[:origin])
    @rows_loaded = params[:rows_loaded].to_i
    @sites = Site.order(:code, :id).limit(@rows_loaded)

    if params[:after].present?
      after = parse_date(params[:after])
      @direction = :forward
      @new_dates = (1..DATE_BATCH).map { |n| after + n }
    else
      before = parse_date(params[:before])
      @direction = :backward
      floor = [before - DATE_BATCH, MIN_DATE].max
      @new_dates = (floor...before).to_a
    end

    respond_to { |format| format.turbo_stream }
  end

  private

  def parse_date(value)
    Date.iso8601(value) if value.present?
  rescue ArgumentError
    nil
  end
  helper_method :parse_date
end

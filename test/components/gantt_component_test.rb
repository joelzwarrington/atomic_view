# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::GanttComponentTest < ViewComponent::TestCase
  ORIGIN = Date.new(2026, 9, 1)
  DATES = (ORIGIN..(ORIGIN + 6)).to_a

  test "renders the grid with the given id" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)).to_html

    assert_includes(actual, "id=\"site-schedule\"")
  end

  test "always renders the gantt controller" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)).to_html

    assert_includes(actual, "data-controller=\"atomic-view--gantt\"")
  end

  test "renders a date header cell for each given date" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)).to_html

    DATES.each { |date| assert_includes(actual, ">#{date.day}<") }
  end

  test "highlights the today column when given" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, today: DATES[2]))

    header_cells = actual.css("#site-schedule_dates > div")
    assert_includes(header_cells[2]["class"], "text-primary")
    assert_not_includes(header_cells[0]["class"], "text-primary")
  end

  test "renders an empty row_pagination turbo-frame when next_rows_path is omitted" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES))

    frame = actual.css("turbo-frame#site-schedule_row_pagination").first
    assert(frame)
    assert_nil(frame["src"])
  end

  test "renders a lazily-loaded row_pagination turbo-frame carrying next_rows_path when given" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, next_rows_path: "/rows?cursor=2"))

    frame = actual.css("turbo-frame#site-schedule_row_pagination").first
    assert_equal("/rows?cursor=2", frame["src"])
    assert_equal("lazy", frame["loading"])
  end

  test "renders no date sentinel when next_dates_path is omitted" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)).to_html

    assert_not_includes(actual, "site-schedule_date_sentinel")
  end

  test "renders a date sentinel carrying next_dates_path when given" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, next_dates_path: "/dates?cursor=2026-09-08")).to_html

    assert_includes(actual, "id=\"site-schedule_date_sentinel\"")
    assert_includes(actual, "data-next-page=\"/dates?cursor=2026-09-08\"")
    assert_includes(actual, "data-atomic-view--gantt-target=\"dateSentinel\"")
  end

  test "renders no date start trigger when prev_dates_path is omitted" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)).to_html

    assert_not_includes(actual, "site-schedule_date_start_trigger")
  end

  test "renders a date start trigger button carrying prev_dates_path when given" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, prev_dates_path: "/dates?before=2026-09-01")).to_html

    assert_includes(actual, "id=\"site-schedule_date_start_trigger\"")
    assert_includes(actual, "data-prev-page=\"/dates?before=2026-09-01\"")
    assert_includes(actual, "data-atomic-view--gantt-target=\"dateStartTrigger\"")
    assert_includes(actual, "data-action=\"click->atomic-view--gantt#loadEarlierDates\"")
    assert_includes(actual, "<button")
  end

  test "renders the empty message when there are no rows" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, empty_message: "No sites yet.")).to_html

    assert_includes(actual, "No sites yet.")
  end

  test "does not render the empty message when there are rows" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, empty_message: "No sites yet.")) { |gantt|
      gantt.with_row(id: "row-1", label: "RS001", origin: ORIGIN)
    }.to_html

    assert_not_includes(actual, "No sites yet.")
  end

  test "renders a RowComponent for each with_row" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES)) { |gantt|
      gantt.with_row(id: "row-1", label: "RS001", origin: ORIGIN)
      gantt.with_row(id: "row-2", label: "RS002", origin: ORIGIN)
    }.to_html

    assert_includes(actual, "RS001")
    assert_includes(actual, "RS002")
  end

  test "appends a consumer-supplied controller rather than overwriting the default" do
    actual = render_inline(
      AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, data: {controller: "extra-controller"})
    ).to_html

    assert_includes(actual, "data-controller=\"atomic-view--gantt extra-controller\"")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: DATES, class: "custom-gantt", data: {testid: "gantt"})
    ).to_html

    assert_includes(actual, "custom-gantt")
    assert_includes(actual, "data-testid=\"gantt\"")
  end

  test "renders day/weekday header labels" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: [Date.new(2026, 9, 1)])).to_html

    assert_includes(actual, ">1<")
    assert_includes(actual, ">Tue<")
  end

  test "date header cells carry no width of their own -- the grid container sizes them" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: [Date.new(2026, 9, 1)], cell_width: 40))

    dates_container = actual.css("#site-schedule_dates").first
    assert_includes(dates_container["class"], "grid")
    assert_includes(dates_container["style"], "grid-auto-columns: 40px")

    cell = actual.css("#site-schedule_dates > div").first
    assert_nil(cell["style"])
  end

  test "renders a month/year band above the day header" do
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: [Date.new(2026, 9, 1)]))

    segment = actual.css("#site-schedule_month_band > div").first
    assert(segment)
    assert_equal("September 2026", segment.text.strip)
  end

  test "splits the month band into one grid segment per calendar month, spanning its day count" do
    dates = (Date.new(2026, 8, 30)..Date.new(2026, 9, 2)).to_a # Aug 30, 31, Sep 1, 2
    actual = render_inline(AtomicView::Components::GanttComponent.new(id: "site-schedule", dates: dates, cell_width: 40))

    month_band = actual.css("#site-schedule_month_band").first
    assert_includes(month_band["class"], "grid")
    assert_includes(month_band["style"], "grid-auto-columns: 40px")

    segments = actual.css("#site-schedule_month_band > div")
    assert_equal(2, segments.size)

    assert_equal("August 2026", segments[0].text.strip)
    assert_includes(segments[0]["style"], "grid-column: span 2")

    assert_equal("September 2026", segments[1].text.strip)
    assert_includes(segments[1]["style"], "grid-column: span 2")
  end

  test "GanttComponent.offset_px matches simple day math" do
    origin = Date.new(2026, 9, 1)
    assert_equal(0, AtomicView::Components::GanttComponent.offset_px(origin, origin: origin, cell_width: 40))
    assert_equal(120, AtomicView::Components::GanttComponent.offset_px(origin + 3, origin: origin, cell_width: 40))
  end

  test "GanttComponent.pack_lanes keeps non-overlapping ranges in the same lane" do
    ranges = [[Date.new(2026, 9, 1), Date.new(2026, 9, 5)], [Date.new(2026, 9, 6), Date.new(2026, 9, 10)]]

    assert_equal([0, 0], AtomicView::Components::GanttComponent.pack_lanes(ranges))
  end

  test "GanttComponent.pack_lanes assigns overlapping ranges to separate lanes" do
    ranges = [[Date.new(2026, 9, 1), Date.new(2026, 9, 5)], [Date.new(2026, 9, 3), Date.new(2026, 9, 8)]]

    assert_equal([0, 1], AtomicView::Components::GanttComponent.pack_lanes(ranges))
  end

  test "GanttComponent.pack_lanes reuses a lane once it frees up" do
    ranges = [
      [Date.new(2026, 9, 1), Date.new(2026, 9, 5)],
      [Date.new(2026, 9, 3), Date.new(2026, 9, 8)],
      [Date.new(2026, 9, 10), Date.new(2026, 9, 12)]
    ]

    assert_equal([0, 1, 0], AtomicView::Components::GanttComponent.pack_lanes(ranges))
  end

  test "GanttComponent.pack_lanes returns lanes in input order regardless of date order" do
    ranges = [[Date.new(2026, 9, 10), Date.new(2026, 9, 12)], [Date.new(2026, 9, 1), Date.new(2026, 9, 5)]]

    assert_equal([0, 0], AtomicView::Components::GanttComponent.pack_lanes(ranges))
  end

  test "GanttComponent.overlaps_range? is true when the ranges share a day" do
    assert(AtomicView::Components::GanttComponent.overlaps_range?(Date.new(2026, 9, 1), Date.new(2026, 9, 5), Date.new(2026, 9, 5), Date.new(2026, 9, 10)))
  end

  test "GanttComponent.overlaps_range? is true when one range fully contains the other" do
    assert(AtomicView::Components::GanttComponent.overlaps_range?(Date.new(2026, 9, 1), Date.new(2026, 9, 30), Date.new(2026, 9, 10), Date.new(2026, 9, 12)))
  end

  test "GanttComponent.overlaps_range? is false when one range ends before the other starts" do
    assert_not(AtomicView::Components::GanttComponent.overlaps_range?(Date.new(2026, 9, 1), Date.new(2026, 9, 4), Date.new(2026, 9, 5), Date.new(2026, 9, 10)))
  end
end

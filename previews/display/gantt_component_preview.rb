module Display
  class GanttComponentPreview < Lookbook::Preview
    # Gantt
    # -----
    # A resource-scheduling grid -- rows are resources (here, campsites),
    # columns are days, and bookings render as bars positioned by real date
    # math rather than a column index. The label column stays pinned while
    # the grid scrolls sideways; scroll the grid down or sideways in a real
    # app (`next_rows_path`/`next_dates_path`/`prev_dates_path`, omitted here
    # since this preview has no backend to fetch from) to load more sites or
    # more days via Turbo -- see `GanttComponent`'s class docs for the full
    # pagination contract, including a worked Pagy-keyset example.
    #
    # `variant:` on each bar maps onto the gem's existing success/warning/
    # destructive/muted/outline tokens -- map your own domain statuses
    # (confirmed/cancelled/pending/...) onto these however fits your app.
    # `href:`, when given, makes a bar a real link (see Karen Wilson's and
    # Tom Bennett's bars below).
    #
    # `origin:` (and `today:`, when highlighting a date) is repeated on
    # every `with_row`/`with_item` call rather than inherited from the
    # parent -- see `GanttComponent`'s class docs for why.
    #
    # RS002, RS003, and RS008 each carry two overlapping bookings -- a
    # confirmed/active stay plus a pending inquiry or maintenance hold
    # against the same dates, which is exactly the case a Gantt needs to
    # show clearly rather than paint on top of itself. Each row's `lanes:`
    # is computed from its own bookings with `GanttComponent.pack_lanes`,
    # same as a real controller would -- see `row_for` below.
    def default
      render(AtomicView::Components::GanttComponent.new(id: "rentals-preview", dates: dates, today: today)) do |gantt|
        sites.each { |site| row_for(gantt, site) }
      end
    end

    private

    # Renders one row plus its bookings, computing `lane:`/`lanes:` from the
    # row's own booking list -- the same thing a real controller action
    # would do before calling `with_row`/`with_item` (see `GanttComponent`'s
    # class docs, "Overlapping bars in the same row").
    def row_for(gantt, site)
      bookings = site[:bookings]
      lanes = AtomicView::Components::GanttComponent.pack_lanes(bookings.map { |b| [b[:starts_on], b[:ends_on]] })

      gantt.with_row(id: site[:id], label: site[:label], sublabel: site[:sublabel], origin: origin, today: today, lanes: (lanes.max || -1) + 1) do |row|
        bookings.zip(lanes).each do |booking, lane|
          row.with_item(**booking, origin: origin, lane: lane)
        end
      end
    end

    def sites
      [
        {id: "rs001", label: "RS001", sublabel: "Riverside", bookings: []},
        {id: "rs002", label: "RS002", sublabel: "Riverside", bookings: [
          {starts_on: origin, ends_on: origin + 19, label: "Karen Wilson · Seasonal", variant: :success, href: "#"},
          {starts_on: origin + 14, ends_on: origin + 17, label: "Inquiry · overlaps stay", variant: :outline}
        ]},
        {id: "rs003", label: "RS003", sublabel: "Riverside", bookings: [
          {starts_on: origin + 5, ends_on: origin + 8, label: "Tom Bennett", variant: :warning, href: "#"},
          {starts_on: origin + 7, ends_on: origin + 10, label: "Waitlist hold", variant: :outline}
        ]},
        {id: "rs004", label: "RS004", sublabel: "Riverside", bookings: [
          {starts_on: origin + 3, ends_on: origin + 5, label: "Marcus Lee", variant: :success}
        ]},
        {id: "rs005", label: "RS005", sublabel: "Riverside", bookings: [
          {starts_on: origin, ends_on: origin + 2, label: "R. Nguyen", variant: :muted}
        ]},
        {id: "rs006", label: "RS006", sublabel: "Riverside", bookings: [
          {starts_on: origin + 9, ends_on: origin + 19, label: "S. Okafor · Seasonal", variant: :warning}
        ]},
        {id: "rs007", label: "RS007", sublabel: "Riverside", bookings: [
          {starts_on: origin + 6, ends_on: origin + 8, label: "Devon Clarke", variant: :destructive}
        ]},
        {id: "rs008", label: "RS008", sublabel: "Riverside", bookings: [
          {starts_on: origin, ends_on: origin + 19, label: "J. Fontaine · Monthly", variant: :success},
          {starts_on: origin + 10, ends_on: origin + 12, label: "Maintenance hold", variant: :muted}
        ]},
        {id: "rs009", label: "RS009", sublabel: "Riverside", bookings: []},
        {id: "rs010", label: "RS010", sublabel: "Riverside", bookings: [
          {starts_on: origin + 11, ends_on: origin + 13, label: "Inquiry · unconfirmed", variant: :outline}
        ]},
        {id: "er002", label: "ER002", sublabel: "Eagle Ridge", bookings: [
          {starts_on: origin, ends_on: origin + 16, label: "Aisha Rahman · Seasonal", variant: :muted}
        ]},
        {id: "er014", label: "ER014", sublabel: "Eagle Ridge", bookings: [
          {starts_on: origin, ends_on: origin + 20, label: "Priya Anand · Monthly", variant: :success}
        ]},
        {id: "er020", label: "ER020", sublabel: "Eagle Ridge", bookings: []},
        {id: "er021", label: "ER021", sublabel: "Eagle Ridge", bookings: [
          {starts_on: origin + 12, ends_on: origin + 14, label: "B. Osei", variant: :success}
        ]},
        {id: "gm008", label: "GM008", sublabel: "Green Mountain", bookings: [
          {starts_on: origin + 19, ends_on: origin + 22, label: "The Delgado Family", variant: :success}
        ]},
        {id: "gm012", label: "GM012", sublabel: "Green Mountain", bookings: [
          {starts_on: origin + 2, ends_on: origin + 19, label: "N. Petrov · Seasonal", variant: :outline}
        ]}
      ]
    end

    def origin
      Date.new(2026, 9, 1)
    end

    def dates
      (origin..(origin + 22)).to_a
    end

    def today
      Date.new(2026, 9, 9)
    end
  end
end

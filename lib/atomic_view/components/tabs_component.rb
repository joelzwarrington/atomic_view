# frozen_string_literal: true

module AtomicView
  module Components
    # Tabs
    #
    # Renders an underlined tab bar for navigating between a record's
    # sub-pages (e.g. Overview/Invoices/Activity). Like
    # SegmentedControlComponent's link mode, `options` are {label:, href:}
    # hashes and `selected` is compared against each option's `label:` --
    # the consumer already has the current tab's display value in hand
    # (e.g. from the request path), so matching on `label:` avoids making
    # every caller build a comparable canonical href.
    #
    # Unlike SegmentedControlComponent's pill track (mutually-exclusive
    # filter chips raised on a muted background), tabs read as page-level
    # navigation -- a plain row of links with a colored underline on the
    # active one, sharing a bottom divider with the rest of the row.
    #
    # Pass `turbo_frame:` to swap tabs without a full page load: every tab
    # link gets a matching `data-turbo-frame`. Wrap *both* this component
    # and the content below it in the same `<turbo-frame id="...">` --
    # not just the content -- so the newly-active tab's underline arrives
    # in the same swap as the new content, rather than the frame updating
    # while the tab bar outside it still shows the old tab active. The
    # component doesn't render that frame itself -- it stays agnostic
    # about the content underneath, the same way it doesn't know
    # what each `href` points to.
    class TabsComponent < AtomicView::Component
      attr_reader :options, :selected, :turbo_frame

      def initialize(options:, selected:, turbo_frame: nil, **html_options)
        super()
        @options = options
        @selected = selected
        @turbo_frame = turbo_frame
        @html_options = html_options
      end

      def active?(option)
        option[:label] == selected
      end

      def container_class
        class_names("flex gap-6 border-b border-border", @html_options[:class])
      end

      def tab_attributes(option)
        attributes = {class: tab_classes(option)}
        attributes[:"aria-current"] = "true" if active?(option)
        attributes[:data] = {turbo_frame: turbo_frame} if turbo_frame.present?
        attributes
      end

      private

      def tab_classes(option)
        class_names(base_classes, active?(option) ? active_classes : inactive_classes)
      end

      def base_classes
        "-mb-px border-b-2 pb-3 text-sm font-semibold"
      end

      def active_classes
        "border-accent text-accent"
      end

      def inactive_classes
        "border-transparent text-muted-foreground hover:text-foreground"
      end
    end
  end
end

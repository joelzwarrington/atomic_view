# frozen_string_literal: true

module AtomicView
  module Components
    # Dropdown
    #
    # A generic trigger + floating menu, positioned by `@floating-ui/dom` and
    # wired to `atomic-view--dropdown` (see
    # `app/assets/javascripts/atomic_view/controllers/dropdown_controller.js`).
    # The controller handles opening/closing, edge-aware positioning
    # (flip/shift so the menu stays on-screen near a viewport edge), closing
    # on an outside click or Esc, and keeping the menu anchored to the
    # trigger while the page scrolls or resizes.
    #
    # This component only provides the trigger/menu structure and wiring --
    # it has no opinion about what's inside either slot. Both the
    # org/park-switcher menu (grouped sections with uppercase labels,
    # dividers, a checkmark on the current selection) and the notification
    # bell flyout (a list of notification rows) are the *same*
    # `DropdownComponent` with different slot content -- compose that markup
    # with existing primitives (e.g. `Badge`/`Avatar`) inside the `menu`
    # slot rather than teaching this component about either use case.
    class DropdownComponent < AtomicView::Component
      renders_one :trigger
      renders_one :menu

      attr_reader :label

      def initialize(label: nil, **options)
        super()
        @label = label
        @options = options
      end

      def html_options
        @options.except(:class, :data, :trigger_class)
      end

      # True when no `trigger` slot was given but `label:` was -- the
      # template falls back to rendering a button with `default_trigger_class`,
      # styled to match `FieldChrome` (the same ring-based border/focus
      # treatment as text fields and selects), instead of every consumer
      # hand-rolling a `border border-border` button that looks subtly
      # different from the rest of the form chrome.
      def default_trigger?
        !trigger? && label.present?
      end

      def default_trigger_class
        "inline-flex h-8 items-center gap-1.5 rounded-btn border-0 px-3 text-sm font-medium shadow-xs ring-1 " \
          "bg-transparent dark:bg-white/5 text-foreground ring-ring/10 dark:ring-white/10 hover:bg-offset " \
          "focus:ring-focus-ring focus:border-ring/20 dark:focus:ring-focus-ring " \
          "disabled:cursor-not-allowed disabled:bg-disabled disabled:text-disabled-foreground disabled:ring-disabled-ring"
      end

      def html_class
        class_names("relative inline-block", @options[:class])
      end

      def trigger_class
        class_names("inline-block", @options[:trigger_class])
      end

      def data_attributes
        (@options[:data] || {}).merge(controller: "atomic-view--dropdown")
      end

      def trigger_data_attributes
        {"atomic-view--dropdown-target" => "trigger", :action => "click->atomic-view--dropdown#toggle"}
      end

      def menu_data_attributes
        {"atomic-view--dropdown-target" => "menu"}
      end

      def menu_class
        "hidden absolute z-50 bg-surface border border-border rounded-card shadow-panel"
      end
    end
  end
end

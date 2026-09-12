module Display
  class DropdownComponentPreview < Lookbook::Preview
    # @!group Examples

    # Org / park switcher
    # -------------------
    # A generic trigger + floating menu, positioned by `@floating-ui/dom`
    # and wired to `atomic-view--dropdown`. It has no opinion about what's
    # inside either slot -- this example and "Notification bell flyout"
    # below are the *same* component with different slot content; compose
    # menu content with existing primitives (`Avatar`, `Badge`, etc.)
    # rather than teaching this component about a specific use case.
    #
    # No host app setup needed for the controller itself -- it's pinned so
    # it's picked up by the same `eagerLoadControllersFrom("controllers",
    # application)` call every Rails + importmap + Stimulus app already has
    # by default.
    #
    # Positioning uses `@floating-ui/dom`, pinned via importmap --
    # `bin/rails atomic_view:install` (the install generator) adds this pin
    # to the host app's `config/importmap.rb` automatically, no manual step
    # needed:
    #
    #   pin "@floating-ui/dom", to: "https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.8.0/+esm"
    def org_switcher
      render_with_template
    end

    # Notification bell flyout
    # -------------------------
    def notifications
      render_with_template
    end

    # Full-width truncating trigger
    # ------------------------------
    # Pass `trigger_class:` (merged via `class_names`/`TailwindMerge`, same
    # as the root `class:` option) to override the trigger wrapper's default
    # `inline-block`. Without this, the wrapper's shrink-to-fit sizing takes
    # its min-content width from the trigger's unbroken text, so a `truncate`
    # span inside never actually ellipsizes even when the root is
    # `flex-1 min-w-0`. `trigger_class: "block min-w-0"` lets the wrapper
    # shrink with its flex container instead.
    def full_width_truncating_trigger
      render_with_template
    end

    # Default trigger from label
    # ---------------------------
    # Passing `label:` without a `trigger` slot renders a default trigger
    # button for you, styled with the same ring-based border/focus treatment
    # as `TextFieldComponent`/`SelectComponent` (via `FieldChrome`) rather
    # than a hand-rolled `border border-border` button -- so a filter
    # dropdown sitting next to a search field lines up instead of looking
    # like it came from a different design system. Still fully overridable:
    # pass a `trigger` slot (as in the examples above) whenever the default
    # button isn't enough.
    def default_trigger_from_label
      render_with_template
    end

    # @!endgroup
  end
end

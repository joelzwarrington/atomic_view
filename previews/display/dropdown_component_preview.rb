module Display
  # Dropdown
  #
  # A generic trigger + floating menu, positioned by `@floating-ui/dom` and
  # wired to `atomic-view--dropdown`. It has no opinion about what's inside
  # either slot -- the two examples below are the *same* component with
  # different slot content; compose menu content with existing primitives
  # (`Avatar`, `Badge`, etc.) rather than teaching this component about a
  # specific use case.
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
  class DropdownComponentPreview < Lookbook::Preview
    # @!group Examples

    # Org / park switcher
    # -------------------
    def org_switcher
      render_with_template
    end

    # Notification bell flyout
    # -------------------------
    def notifications
      render_with_template
    end

    # @!endgroup
  end
end

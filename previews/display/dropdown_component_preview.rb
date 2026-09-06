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
  # The gem can't register a controller into a host app's own Stimulus
  # `Application` instance, so add this to the host app's
  # `app/javascript/controllers/index.js`:
  #
  #   import DropdownController from "atomic_view/controllers/dropdown_controller"
  #   application.register("atomic-view--dropdown", DropdownController)
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

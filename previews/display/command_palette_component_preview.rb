module Display
  class CommandPaletteComponentPreview < Lookbook::Preview
    # Command palette
    # ---------------
    # A `Cmd/Ctrl+K` search dialog wired to `atomic-view--command-palette`.
    # Once registered, `Cmd/Ctrl+K` opens the dialog from anywhere on the
    # page -- the controller listens for it on `document`, so no trigger
    # element is required (the button in the example below is just a
    # discoverable alternative). Type to filter, Up/Down to move between
    # results, Enter to activate the highlighted one.
    #
    # Results are passed as plain data (see `CommandPaletteComponent`'s class
    # docs for the shape); the controller filters rows client-side as the
    # user types and supports arrow-key navigation.
    #
    # No host app setup needed -- the controller is pinned so it's picked up
    # by the same `eagerLoadControllersFrom("controllers", application)`
    # call every Rails + importmap + Stimulus app already has by default.
    def default
      render_with_template
    end
  end
end

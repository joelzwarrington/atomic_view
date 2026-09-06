module Display
  # Command palette
  #
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
  # The gem can't register a controller into a host app's own Stimulus
  # `Application` instance, so add this to the host app's
  # `app/javascript/controllers/index.js`:
  #
  #   import CommandPaletteController from "atomic_view/controllers/command_palette_controller"
  #   application.register("atomic-view--command-palette", CommandPaletteController)
  class CommandPaletteComponentPreview < Lookbook::Preview
    def default
      render_with_template
    end
  end
end

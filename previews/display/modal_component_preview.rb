module Display
  class ModalComponentPreview < Lookbook::Preview
    # @!group Examples

    # Plain modal
    # -----------
    # A confirmation dialog built on the native `<dialog>` element. Opening
    # it from elsewhere on the page (a trigger button, a link in a table
    # row, etc.) is the host app's concern -- the trigger doesn't need to
    # be inside the dialog, so a plain `showModal()` call is simplest.
    # Elements *inside* the dialog (like the footer's Cancel button below)
    # can use a Stimulus action instead, since they're descendants of the
    # `<dialog>` that carries the controller:
    # `data-action="click->atomic-view--modal#close"`.
    #
    # `footer` is a slot -- typically a Cancel/Confirm button pair.
    #
    # Wired to `atomic-view--modal`. No host app setup needed -- the
    # controller is pinned so it's picked up by the same
    # `eagerLoadControllersFrom("controllers", application)` call every
    # Rails + importmap + Stimulus app already has by default.
    #
    # @param title text "The modal's heading"
    def default(title: "Update your plan")
      render_with_template(locals: {title: title})
    end

    # Danger / delete-confirmation modal
    # -----------------------------------
    # Set `danger: true` to show a warning icon next to the title -- use it
    # for destructive, hard-to-reverse actions.
    #
    # @param title text "The modal's heading"
    def danger(title: "Delete project?")
      render_with_template(locals: {title: title})
    end

    # @!endgroup
  end
end

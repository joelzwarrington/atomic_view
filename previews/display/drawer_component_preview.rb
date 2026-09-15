module Display
  class DrawerComponentPreview < Lookbook::Preview
    # @!group Examples

    # Plain drawer
    # ------------
    # A side panel built on the native `<dialog>` element, pinned to the
    # right edge and stretched to full height. Opening it from elsewhere on
    # the page works the same way as `ModalComponent` -- a plain
    # `showModal()` call, since the trigger doesn't need to be inside the
    # dialog. Elements *inside* the drawer (the header's close button, the
    # footer's Cancel button) use a Stimulus action instead:
    # `data-action="click->atomic-view--drawer#close"`.
    #
    # `actions` is a slot for header-level buttons that aren't the close
    # button itself (e.g. "Save as draft" here). `footer` is a slot for the
    # bottom button row -- its Confirm button submits the body's
    # `form_with` via the HTML `form="..."` attribute rather than nesting,
    # since the header/body/footer are separate containers; see
    # `DrawerComponent`'s class docs for the full pattern.
    #
    # Wired to `atomic-view--drawer`. No host app setup needed -- the
    # controller is pinned so it's picked up by the same
    # `eagerLoadControllersFrom("controllers", application)` call every
    # Rails + importmap + Stimulus app already has by default.
    #
    # @param title text "The drawer's heading"
    def default(title: "Add a product")
      render_with_template(locals: {id: "drawer-component-preview-default", title: title, side: :right})
    end

    # Opened from the left
    # ---------------------
    # Pass `side: :left` to pin the drawer to the opposite edge instead --
    # everything else about it (backdrop click-to-close, header/footer
    # layout, Turbo behavior) stays the same.
    #
    # @param title text "The drawer's heading"
    def left_side(title: "Filter results")
      render_with_template(locals: {id: "drawer-component-preview-left-side", title: title, side: :left}, template: "display/drawer_component_preview/default")
    end

    # @!endgroup

    # Opened directly (no trigger)
    # -----------------------------
    # `open: true` is what lets the exact same `DrawerComponent` render
    # work two different ways: triggered from elsewhere on the page (the
    # examples above), or -- as here -- already open the moment the page
    # itself loads, with no JS call needed. That's the shape a direct visit
    # to e.g. `/products/new` should take: render the underlying page as
    # normal, with this drawer included in that same response, `open: true`.
    #
    # A Turbo Stream response that replaces or updates a container already
    # on the page with a fresh render of this same component (again
    # `open: true`) reaches the identical result without a full page load --
    # see `DrawerComponent`'s class docs for the full pattern. Either way,
    # `atomic-view--drawer` never needs a bespoke "please open now" event:
    # `connect()` sees `open: true` and calls `showModal()` itself.
    #
    # Kept off the "Examples" group above (rather than stacked alongside
    # Default/Left Side) since a full-height `open: true` drawer covers the
    # whole viewport, including whatever else is on the page -- true to how
    # it'd behave as a real standalone route, but not something you want
    # sharing a page with other triggers you still need to click.
    def opened_directly
      render_with_template
    end
  end
end

module Display
  class ToastComponentPreview < Lookbook::Preview
    # @!group Variants

    # Success
    # -------
    # A single, self-dismissing notification -- render one per toast and
    # let the host app stack them, e.g.:
    #
    #   <div class="fixed bottom-4 right-4 flex flex-col-reverse gap-2 z-50">
    #     <%= render AtomicView::Components::ToastComponent.new(title: "Saved") %>
    #   </div>
    #
    # Wired to `atomic-view--toast`. No host app setup needed -- the
    # controller is pinned so it's picked up by the same
    # `eagerLoadControllersFrom("controllers", application)` call every
    # Rails + importmap + Stimulus app already has by default.
    #
    # @param title text "The toast's heading"
    # @param description textarea "Optional supporting copy"
    def success(title: "Changes saved", description: "Your profile has been updated.")
      render AtomicView::Components::ToastComponent.new(variant: :success, title: title, description: description)
    end

    # Error
    # -----
    # @param title text "The toast's heading"
    # @param description textarea "Optional supporting copy"
    def error(title: "Something went wrong", description: "We couldn't save your changes. Please try again.")
      render AtomicView::Components::ToastComponent.new(variant: :error, title: title, description: description)
    end

    # Info
    # ----
    # @param title text "The toast's heading"
    # @param description textarea "Optional supporting copy"
    def info(title: "Heads up", description: "Your session will expire in 5 minutes.")
      render AtomicView::Components::ToastComponent.new(variant: :info, title: title, description: description)
    end

    # @!endgroup

    # Dismiss button
    # --------------
    # Set `dismissible: false` to hide the "x" button -- e.g. for a toast
    # reporting background progress the user shouldn't be able to cut
    # short. When shown, it's wired to `click->atomic-view--toast#dismiss`;
    # click it to confirm the controller removes the toast from the DOM.
    #
    # @param dismissible toggle
    def dismiss(dismissible: true)
      render AtomicView::Components::ToastComponent.new(
        variant: :info, title: "Syncing in the background", dismissible: dismissible
      )
    end

    # Auto-dismiss
    # ------------
    # `auto_dismiss_ms` schedules the controller's own dismiss on
    # `connect()` -- reload this preview to watch it disappear after the
    # delay below.
    #
    # @param auto_dismiss_ms number "Delay in milliseconds before the toast dismisses itself"
    def auto_dismiss(auto_dismiss_ms: 4000)
      render AtomicView::Components::ToastComponent.new(
        variant: :success, title: "Copied to clipboard", auto_dismiss_ms: auto_dismiss_ms
      )
    end
  end
end

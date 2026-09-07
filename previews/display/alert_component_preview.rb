module Display
  class AlertComponentPreview < Lookbook::Preview
    # @!group Variants

    # Info
    # ----
    # The default variant. Use it for neutral, non-urgent context the user
    # should notice but doesn't need to act on immediately.
    #
    # @param content text "The alert's body copy"
    def info(content: "A new version of this page is available.")
      render AtomicView::Components::AlertComponent.new do
        content
      end
    end

    # Success
    # -------
    # Confirms an action completed as expected — a save, a submission, a
    # completed sync.
    #
    # @param content text "The alert's body copy"
    def success(content: "Your changes have been saved.")
      render AtomicView::Components::AlertComponent.new(variant: :success) do
        content
      end
    end

    # Warning
    # -------
    # Flags something that isn't broken yet but needs attention soon — a
    # limit approaching, a setting that will change behavior elsewhere.
    #
    # @param content text "The alert's body copy"
    def warning(content: "You have no credits left.")
      render AtomicView::Components::AlertComponent.new(variant: :warning) do
        content
      end
    end

    # Error
    # -----
    # Reports that something failed or is currently broken and needs
    # action.
    #
    # @param content text "The alert's body copy"
    def error(content: "We couldn't process your payment.")
      render AtomicView::Components::AlertComponent.new(variant: :error) do
        content
      end
    end

    # @!endgroup

    # With a title
    # ------------
    # Pass `title` to add a bold heading above the body copy — useful once
    # the message needs more than a single line to explain itself.
    #
    # @param title text
    # @param content text "The alert's body copy"
    def with_title(title: "Payment failed", content: "We couldn't charge your card ending in 4242. Update your payment method to avoid a service interruption.")
      render AtomicView::Components::AlertComponent.new(variant: :error, title: title) do
        content
      end
    end

    # With a link
    # -----------
    # The body is a regular content block, so it can hold any markup —
    # including a call-to-action link, styled however the host app likes.
    def with_link
      render AtomicView::Components::AlertComponent.new(variant: :warning) do
        "You have no credits left. ".html_safe +
          tag.a("Upgrade your account to add more credits.", href: "#", class: "font-medium underline hover:opacity-80")
      end
    end
  end
end

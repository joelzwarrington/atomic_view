module Forms
  class ButtonComponentPreview < Lookbook::Preview
    # @!group Variants

    # Primary
    # -------
    # The default call-to-action style. Use it for the single most
    # important action on a form or in a section — generally only one
    # primary button per screen, so it's obvious what to do next.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def primary(content: "Save", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Secondary
    # ---------
    # A lower-emphasis action placed alongside a primary button — e.g.
    # "Cancel" next to "Save". Use it for actions that matter but
    # shouldn't compete visually with the primary action.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def secondary(content: "Cancel", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Destructive
    # -----------
    # Signals a dangerous, hard-to-reverse action — deleting a record,
    # removing a member. Pair it with a confirmation step for anything
    # that can't be undone.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def destructive(content: "Delete", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Muted
    # -----
    # A quiet, low-visual-weight button for auxiliary actions that need to
    # be clickable but shouldn't draw the eye — an inline "Edit" or
    # "Dismiss" action in a toolbar or table row.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def muted(content: "Edit", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Link
    # ----
    # Renders like an inline text link rather than a button. Use it when
    # the action should read as a hyperlink within a sentence or a compact
    # row of actions, not a standalone control.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def link(content: "Learn more", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Outline
    # -------
    # A bordered, transparent-background button. Reach for it as a
    # secondary action on a colored or image background where a filled
    # `secondary` button would clash, or anywhere you want something
    # lighter than `secondary`.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def outline(content: "View details", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # @!endgroup
  end
end

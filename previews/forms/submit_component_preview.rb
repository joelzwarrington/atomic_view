module Forms
  class SubmitComponentPreview < Lookbook::Preview
    # @!group Variants

    # Primary
    # -------
    # The default submit button style — use it for the form's main submit
    # action. Prefer this over `ButtonComponent` whenever the control
    # should actually submit the enclosing form (`type="submit"`) rather
    # than trigger arbitrary JS/navigation.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def primary(content: "Save", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Secondary
    # ---------
    # A lower-emphasis submit action — e.g. "Save as draft" alongside a
    # primary "Publish" submit button.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def secondary(content: "Save as draft", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Destructive
    # -----------
    # For a submit action with a dangerous or hard-to-reverse effect, such
    # as a form that confirms a deletion.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def destructive(content: "Delete account", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Muted
    # -----
    # A quiet submit action for a form where the submit isn't the focal
    # point of the screen — e.g. a small inline settings form.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def muted(content: "Update", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Link
    # ----
    # A submit button styled as an inline text link — use it for a
    # low-friction, low-emphasis form submission (e.g. "Skip this step").
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def link(content: "Skip for now", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # Outline
    # -------
    # A bordered, transparent-background submit button — a lighter
    # alternative to `secondary` for the same lower-emphasis submit cases.
    #
    # @param content text "The button's label"
    # @param disabled toggle
    def outline(content: "Preview changes", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, content: content, disabled: disabled})
    end

    # @!endgroup
  end
end

module Forms
  class TextFieldComponentPreview < Lookbook::Preview
    # @!group Examples

    # Default
    # -------
    # A single-line `<input type="text">` — the general-purpose text
    # input. Prefer a more specific field (`email_field`, `url_field`,
    # `password_field`, etc.) whenever the value has a well-known shape;
    # they get the right mobile keyboard and browser validation for free.
    #
    # Turn on `error` to preview the invalid-state ring, which is applied
    # automatically whenever the bound attribute has validation errors.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    # @param error toggle "Simulates a validation error on the field"
    def default(label: "Name", placeholder: "Jane Doe", required: false, disabled: false, error: false)
      model = AtomicView::Model.new
      model.errors.add(:attribute, :blank, message: "can't be blank") if error
      render_with_template(locals: {model: model, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end

    # With a leading icon
    # -------------------
    # Pass `left_section` (without `left_section_as_addon`/`_as_interaction`)
    # to place a plain, non-interactive icon inside the field — a quick
    # visual hint about what belongs in the field (e.g. a magnifying glass,
    # an @ symbol) without taking up a whole addon segment.
    #
    # @param label text "The field's label"
    # @param placeholder text
    def with_left_icon(label: "Search", placeholder: "Search campsites...")
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder})
    end

    # With a trailing icon
    # --------------------
    # The same non-interactive icon treatment as the leading-icon example,
    # placed on the right instead — useful for a unit hint, a status
    # glyph, or anything that reads more naturally after the value.
    #
    # @param label text "The field's label"
    # @param placeholder text
    def with_right_icon(label: "Amount", placeholder: "0.00")
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder})
    end

    # With a leading addon
    # --------------------
    # Set `left_section_as_addon: true` to render `left_section` as a
    # bordered, filled segment fused to the field — e.g. a fixed protocol
    # or currency prefix the user isn't meant to edit.
    #
    # @param label text "The field's label"
    # @param placeholder text
    def with_left_addon(label: "Website", placeholder: "example.com")
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder})
    end

    # With a trailing addon
    # ---------------------
    # The addon treatment on the right instead — e.g. a fixed unit or
    # domain suffix that belongs after the typed value.
    #
    # @param label text "The field's label"
    # @param placeholder text
    def with_right_addon(label: "Subdomain", placeholder: "acme")
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder})
    end

    # With an interactive addon
    # -------------------------
    # Set `left_section_as_interaction`/`right_section_as_interaction` to
    # place an actual control (a button, a select) directly attached to
    # the field, rather than a static addon. Use this sparingly — it reads
    # as a single compound control, so it's best for things like a unit
    # picker or an attached action button.
    #
    # @param label text "The field's label"
    # @param placeholder text
    def with_interactive_addon(label: "Amount", placeholder: "0.00")
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder})
    end

    # @!endgroup
  end
end

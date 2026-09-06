module Forms
  class SearchFieldComponentPreview < Lookbook::Preview
    # Search field
    # ------------
    # Renders `<input type="search">`, which gets a native "clear" button
    # in most browsers and is announced as a search field to assistive
    # tech. Use it for search boxes instead of a plain `text_field`.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Search", placeholder: "Search campsites...", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end

module Layout
  class PageComponentPreview < Lookbook::Preview
    # Full layout
    # -----------
    # Every region filled in, reproducing the shape of a real record's
    # detail page: header (breadcrumb + title + badge + subtitle + actions),
    # a full-width `highlight` region below it, a two-column body with a
    # `sidebar`, and default content as the main column. `highlight` and
    # `sidebar` are placeholder boxes here on purpose — this component owns
    # layout only, not what goes inside them (a lifecycle stepper, a details
    # panel, or anything else is the caller's choice). The same shell fits
    # edit/new form pages -- the form is just content in the main column.
    def default
      render_with_template
    end

    # No sidebar
    # ----------
    # When `sidebar` is omitted, the main column spans full width instead of
    # leaving an empty second column.
    def without_sidebar
      render_with_template
    end
  end
end

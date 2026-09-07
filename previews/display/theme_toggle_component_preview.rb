module Display
  class ThemeToggleComponentPreview < Lookbook::Preview
    # Theme toggle
    # ------------
    # Flips the `.dark` class on `<html>` and persists the choice to
    # `localStorage`, falling back to the OS's `prefers-color-scheme` the
    # first time a visitor arrives with no stored choice. Click it, then
    # switch Lookbook's own theme selector to confirm both stay in sync --
    # they're driven by the same `.dark` class.
    #
    # The sun/moon crossfade is pure CSS; see `ThemeToggleComponent`'s
    # class docs for the FOUC-prevention script a host app's `<head>`
    # should add (Stimulus only connects after the DOM already painted
    # once).
    def default
      render(AtomicView::Components::ThemeToggleComponent.new)
    end
  end
end

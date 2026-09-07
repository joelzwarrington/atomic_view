# frozen_string_literal: true

module AtomicView
  module Components
    # ThemeToggle
    #
    # A button that flips the `.dark` class on `<html>` -- the convention
    # engine.css itself documents (see its "Explicit .dark class toggle
    # only" comment) -- between light and dark, persisting the choice to
    # `localStorage` and falling back to the OS preference
    # (`prefers-color-scheme`) the first time a visitor arrives with no
    # stored choice.
    #
    # The sun/moon crossfade is pure CSS (`dark:` utility classes, which
    # resolve off that same `.dark` class per engine.css's
    # `@custom-variant dark`) -- the `atomic-view--theme-toggle` Stimulus
    # controller only toggles the class and persists it, no host app JS
    # required, same as every other atomic_view controller (auto-pinned
    # per config/importmap.rb).
    #
    # Applying `.dark` before first paint (to avoid a flash of the wrong
    # theme) is the host app's concern -- a small inline script in
    # `<head>`, e.g.:
    #
    #   <script>
    #     try {
    #       var t = localStorage.getItem("atomic-view-theme");
    #       var dark = t ? t === "dark" : matchMedia("(prefers-color-scheme: dark)").matches;
    #       if (dark) document.documentElement.classList.add("dark");
    #     } catch (e) {}
    #   </script>
    #
    # This is the same FOUC-prevention step any dark-mode toggle needs,
    # since Stimulus only connects after the DOM has already painted once.
    class ThemeToggleComponent < AtomicView::Component
      def initialize(**options)
        super()
        @options = options
      end

      def call
        tag.button(
          **@options.except(:class),
          type: "button",
          class: class_names(base_classes, @options[:class]),
          data: {controller: "atomic-view--theme-toggle", action: "click->atomic-view--theme-toggle#toggle"},
          aria: {label: "Toggle theme"}
        ) { safe_join([sun_icon, moon_icon]) }
      end

      private

      def base_classes
        "relative inline-flex size-8 items-center justify-center rounded-full text-muted-foreground hover:bg-offset hover:text-foreground"
      end

      def sun_icon
        icon("sun", options: {class: sun_classes}).to_s.html_safe
      end

      def moon_icon
        icon("moon", options: {class: moon_classes}).to_s.html_safe
      end

      def sun_classes
        "absolute size-4 rotate-0 scale-100 opacity-100 transition-all duration-300 dark:rotate-90 dark:scale-50 dark:opacity-0"
      end

      def moon_classes
        "absolute size-4 -rotate-90 scale-50 opacity-0 transition-all duration-300 dark:rotate-0 dark:scale-100 dark:opacity-100"
      end
    end
  end
end

# frozen_string_literal: true

module AtomicView
  module Components
    # Link
    #
    # A button-styled anchor tag -- shares ButtonComponent's variants
    # (`primary`, `secondary`, `destructive`, `muted`, `link`, `outline`) via
    # the same ButtonVariants concern, so a navigational action (e.g. "New
    # record") can sit next to real buttons without looking out of place.
    #
    # `keybinds:`, when given (a single key, or an array for a simultaneous
    # chord, e.g. `["⌘", "K"]` -- same `Array(...)`-of-keys convention as
    # `CommandPaletteComponent::RowComponent#hint`), renders a KbdComponent
    # per key after the content as a visual hint, and wires the anchor to
    # `atomic-view--hotkey` (see
    # `app/assets/javascripts/atomic_view/controllers/hotkey_controller.js`)
    # so pressing the combo anywhere on the page actually clicks it.
    # Modifier symbols/names (⌘/cmd/command, ⇧, ⌃/control, ⌥/option) are
    # normalized to Stimulus's own modifier names (meta/shift/ctrl/alt) for
    # the underlying `keydown.<filter>@window->atomic-view--hotkey#click`
    # action; any other key is lowercased as-is (e.g. "N" -> "n").
    class LinkComponent < AtomicView::Component
      include AtomicView::Components::Concerns::ButtonVariants

      MODIFIER_ALIASES = {
        "⌘" => "meta", "cmd" => "meta", "command" => "meta",
        "⇧" => "shift",
        "⌃" => "ctrl", "control" => "ctrl",
        "⌥" => "alt", "option" => "alt"
      }.freeze

      attr_reader :href, :variant, :keybinds

      def initialize(href, variant: :primary, keybinds: nil, **options)
        super()
        @href = href
        @variant = variant
        @keybinds = Array(keybinds)
        @options = options
      end

      def html_options
        @options.except(:class, :data).merge(class: html_class, data: data_attributes)
      end

      def html_class
        class_names(base_classes, variant_classes, @options[:class])
      end

      def data_attributes
        attributes = (@options[:data] || {}).dup
        return attributes unless keybinds.present?

        attributes[:controller] = [attributes[:controller], "atomic-view--hotkey"].compact.join(" ")
        attributes[:action] = [attributes[:action], "keydown.#{keydown_filter}@window->atomic-view--hotkey#click"].compact.join(" ")
        attributes
      end

      private

      def keydown_filter
        keybinds.map { |key| MODIFIER_ALIASES[key.to_s.downcase] || key.to_s.downcase }.join("+")
      end
    end
  end
end

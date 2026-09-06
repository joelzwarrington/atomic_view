# Palette
#
# Every color token defined in `@theme` (`app/assets/tailwind/atomic_view/engine.css`)
# -- the single source of truth for every `bg-*`/`text-*`/`border-*`/`ring-*`
# utility this design system uses. Swatches reflect whichever theme is
# active (see the light/dark toggle above), since each is rendered with
# the real utility class rather than a hardcoded hex value.
#
# A host app re-themes the whole library by overriding these same custom
# properties -- no component ever hardcodes a color outside this list.
#
# `swatch_class` below is written out in full (e.g. "bg-primary-foreground")
# rather than built with string interpolation, since Tailwind's content
# scanner only generates a utility for class names it finds as complete,
# literal text in a `@source`d file -- a computed/interpolated class name
# would never be generated.
class PalettePreview < Lookbook::Preview
  SECTIONS = [
    {
      heading: "Surfaces & structure",
      tokens: [
        {name: "offset", swatch_class: "bg-offset", description: "The page canvas background other surfaces sit on top of; also doubles as a subtle hover background (hover:bg-offset)."},
        {name: "surface", swatch_class: "bg-surface", description: "Card and panel backgrounds that sit on top of offset."},
        {name: "backdrop", swatch_class: "bg-backdrop", description: "Overlay behind an open modal or dialog's ::backdrop."},
        {name: "border", swatch_class: "bg-border", description: "Default border color for cards, dividers, and panels."},
        {name: "input", swatch_class: "bg-input", description: "Border color for form inputs, kept separate from border so a host app can distinguish them."},
        {name: "ring", swatch_class: "bg-ring", description: "Border/ring color for focused or emphasized interactive elements."}
      ]
    },
    {
      heading: "Text",
      tokens: [
        {name: "foreground", swatch_class: "bg-foreground", description: "Default body, label, and input text color. Never reuse primary for text -- that's reserved for the brand action color."},
        {name: "placeholder", swatch_class: "bg-placeholder", description: "Default placeholder text color for form inputs."}
      ]
    },
    {
      heading: "Brand & semantic",
      tokens: [
        {name: "primary", swatch_class: "bg-primary", description: "Brand action color: primary buttons, links, and active/selected states."},
        {name: "primary-foreground", swatch_class: "bg-primary-foreground", description: "Text and icon color on top of a primary background."},
        {name: "secondary", swatch_class: "bg-secondary", description: "Lower-emphasis button and background color, e.g. a Cancel button next to a primary Save."},
        {name: "secondary-foreground", swatch_class: "bg-secondary-foreground", description: "Text color on top of a secondary background."},
        {name: "muted", swatch_class: "bg-muted", description: "De-emphasized background for auxiliary UI, e.g. a quiet button or a subdued badge."},
        {name: "muted-foreground", swatch_class: "bg-muted-foreground", description: "De-emphasized text color: captions, hints, secondary metadata."},
        {name: "accent", swatch_class: "bg-accent", description: "Reserved for a distinct accent/highlight state. Not yet used by any component -- available for a host app to build on."},
        {name: "accent-foreground", swatch_class: "bg-accent-foreground", description: "Text/icon color paired with accent."},
        {name: "destructive", swatch_class: "bg-destructive", description: "Dangerous, hard-to-reverse actions: delete buttons, error badges, destructive confirmations."},
        {name: "destructive-foreground", swatch_class: "bg-destructive-foreground", description: "Text/icon color on top of a destructive background."},
        {name: "success", swatch_class: "bg-success", description: "Positive/successful state: success toasts, confirmation badges."},
        {name: "success-foreground", swatch_class: "bg-success-foreground", description: "Text/icon color on top of a success background."}
      ]
    },
    {
      heading: "Disabled state",
      tokens: [
        {name: "disabled", swatch_class: "bg-disabled", description: "Background for a disabled form control."},
        {name: "disabled-foreground", swatch_class: "bg-disabled-foreground", description: "Text color for a disabled form control."},
        {name: "disabled-ring", swatch_class: "bg-disabled-ring", description: "Ring color for a disabled form control."}
      ]
    },
    {
      heading: "Validation state",
      tokens: [
        {name: "error", swatch_class: "bg-error", description: "Text color for an invalid form field."},
        {name: "error-ring", swatch_class: "bg-error-ring", description: "Ring color for an invalid form field."},
        {name: "error-placeholder", swatch_class: "bg-error-placeholder", description: "Placeholder text color for an invalid form field."},
        {name: "error-focus-ring", swatch_class: "bg-error-focus-ring", description: "Focus ring color for an invalid form field."}
      ]
    },
    {
      heading: "Other",
      tokens: [
        {name: "focus-ring", swatch_class: "bg-focus-ring", description: "Default focus ring color for a valid (non-error) form field."}
      ]
    }
  ].freeze

  def default
    render_with_template(locals: {sections: SECTIONS})
  end
end

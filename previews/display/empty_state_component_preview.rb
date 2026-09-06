module Display
  class EmptyStateComponentPreview < Lookbook::Preview
    # Empty state
    # -----------
    # Placeholder content for a section, list, or page that currently has
    # nothing to show — an empty inbox, a filtered list with no matches, a
    # collection the user hasn't populated yet. Pair the icon, title, and
    # description with the situation, and give it an action when there's a
    # clear next step (e.g. "Add camper"). Leave `action_text` blank for
    # purely informational empty states where there's nothing for the user
    # to do.
    #
    # The icon is a slot (`with_icon`), not a name string — pass it whatever
    # rendered content makes sense (a Heroicon, an image, initials) rather
    # than being limited to one icon set.
    #
    # @param icon_name select { choices: [users, inbox, map] }
    # @param title text "The empty state's heading"
    # @param description textarea "Optional supporting copy"
    # @param action_text text "Optional call-to-action button label — leave blank to hide the button"
    def default(icon_name: "users", title: "No campers yet", description: "Get started by adding your first camper.", action_text: "Add camper")
      render_with_template(locals: {icon_name: icon_name, title: title, description: description, action_text: action_text})
    end
  end
end

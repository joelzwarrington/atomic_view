module Display
  class NavigationTreeComponentPreview < Lookbook::Preview
    def default
      render_with_template
    end

    # Collapsed (icon-only)
    # ----------------------
    # `collapsed: true` renders an icon-only rail -- labels, chevrons, and
    # any open group's nested items are hidden with CSS, not swapped out in
    # Ruby (a `group/nav` marker on the root plus `group-data-[collapsed]/nav:*`
    # variants on each item). Each item is wrapped in a `TooltipComponent` so
    # the item's name is still available on hover, since the icon alone
    # loses it.
    def collapsed
      render_with_template
    end
  end
end

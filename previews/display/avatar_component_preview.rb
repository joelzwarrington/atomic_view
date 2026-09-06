module Display
  class AvatarComponentPreview < Lookbook::Preview
    # @param src url "Image URL, leave blank to render the initials fallback"
    # @param initials text "Shown when no image src is given"
    # @param size [Symbol] select { choices: [sm, md, lg] }
    def playground(src: nil, initials: "JW", size: :md)
      render AtomicView::Components::AvatarComponent.new(src: src, initials: initials, size: size)
    end
  end
end

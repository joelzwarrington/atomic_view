# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::AvatarComponentTest < ViewComponent::TestCase
  test "renders an image when src is present" do
    actual = render_inline(AtomicView::Components::AvatarComponent.new(src: "https://placehold.co/48x48")).to_html.strip
    expected = <<~HTML.strip
      <img class="rounded-full object-cover size-8" src="https://placehold.co/48x48">
    HTML

    assert_equal(expected, actual)
  end

  test "renders initials fallback when src is absent" do
    actual = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW")).to_html.strip
    expected = <<~HTML.strip
      <span class="flex items-center justify-center rounded-full font-medium bg-[#e9c46a] text-black size-8 text-sm">KW</span>
    HTML

    assert_equal(expected, actual)
  end

  test "renders a default background when no initials are given" do
    actual = render_inline(AtomicView::Components::AvatarComponent.new).to_html.strip
    expected = <<~HTML.strip
      <span class="flex items-center justify-center rounded-full font-medium bg-offset text-foreground size-8 text-sm"></span>
    HTML

    assert_equal(expected, actual)
  end

  test "consistently picks the same palette color for the same initials" do
    first = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW")).to_html.strip
    second = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW")).to_html.strip

    assert_equal(first, second)
  end

  test "picks different palette colors for different initials" do
    kw = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW")).to_html.strip
    ab = render_inline(AtomicView::Components::AvatarComponent.new(initials: "AB")).to_html.strip

    refute_equal(kw, ab)
  end

  test "renders small size for both src and initials" do
    image = render_inline(AtomicView::Components::AvatarComponent.new(src: "https://placehold.co/48x48", size: :sm)).to_html.strip
    assert_includes(image, "size-6")

    fallback = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW", size: :sm)).to_html.strip
    assert_includes(fallback, "size-6")
    assert_includes(fallback, "text-xs")
  end

  test "renders medium size for both src and initials" do
    image = render_inline(AtomicView::Components::AvatarComponent.new(src: "https://placehold.co/48x48", size: :md)).to_html.strip
    assert_includes(image, "size-8")

    fallback = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW", size: :md)).to_html.strip
    assert_includes(fallback, "size-8")
    assert_includes(fallback, "text-sm")
  end

  test "renders large size for both src and initials" do
    image = render_inline(AtomicView::Components::AvatarComponent.new(src: "https://placehold.co/48x48", size: :lg)).to_html.strip
    assert_includes(image, "size-10")

    fallback = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW", size: :lg)).to_html.strip
    assert_includes(fallback, "size-10")
    assert_includes(fallback, "text-base")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(AtomicView::Components::AvatarComponent.new(initials: "KW", class: "custom-avatar", id: "user-avatar")).to_html.strip
    expected = <<~HTML.strip
      <span id="user-avatar" class="flex items-center justify-center rounded-full font-medium bg-[#e9c46a] text-black size-8 text-sm custom-avatar">KW</span>
    HTML

    assert_equal(expected, actual)
  end

  test "merges custom class onto the image variant" do
    actual = render_inline(AtomicView::Components::AvatarComponent.new(src: "https://placehold.co/48x48", class: "custom-avatar", id: "user-avatar")).to_html.strip
    expected = <<~HTML.strip
      <img id="user-avatar" class="rounded-full object-cover size-8 custom-avatar" src="https://placehold.co/48x48">
    HTML

    assert_equal(expected, actual)
  end
end

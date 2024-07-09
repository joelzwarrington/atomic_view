# frozen_string_literal: true

# ButtonComponent
class ButtonComponentPreview < ViewComponent::Preview
  def default
    render AtomicView::Components::ButtonComponent.new("Click Me")
  end

  # @!group Sizes

  def xs
    render AtomicView::Components::ButtonComponent.new("Click Me", size: :xs)
  end

  def sm
    render AtomicView::Components::ButtonComponent.new("Click Me", size: :sm)
  end

  def md
    render AtomicView::Components::ButtonComponent.new("Click Me", size: :md)
  end

  def lg
    render AtomicView::Components::ButtonComponent.new("Click Me", size: :lg)
  end

  # @!endgroup

  # @!group Variants

  def primary
    render AtomicView::Components::ButtonComponent.new("Click Me", variant: :primary)
  end

  def secondary
    render AtomicView::Components::ButtonComponent.new("Click Me", variant: :secondary)
  end

  def tertiary
    render AtomicView::Components::ButtonComponent.new("Click Me", variant: :tertiary)
  end

  # @!endgroup
end

# frozen_string_literal: true

# ButtonComponent
class ButtonComponentPreview < ViewComponent::Preview
  def default
    render AtomicView::Components::ButtonComponent.new("Do Things")
  end
end

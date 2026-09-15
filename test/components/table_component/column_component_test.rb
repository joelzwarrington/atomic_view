# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TableComponent::ColumnComponentTest < ViewComponent::TestCase
  test "defaults the label from the model's human_attribute_name" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(model: Booking, attribute: :camper_name)).to_html

    assert_includes(actual, "Camper name")
  end

  test "uses the given label instead of the model's attribute name" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(model: Booking, attribute: :camper_name, label: "Camper")).to_html

    assert_includes(actual, "Camper")
    assert_not_includes(actual, "Camper name")
  end

  test "allows a label-only column with no model or attribute" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Actions")).to_html

    assert_includes(actual, "Actions")
  end

  test "raises when neither model nor label is given" do
    assert_raises(ArgumentError) { AtomicView::Components::TableComponent::ColumnComponent.new(attribute: :camper_name) }
  end

  test "renders a th with scope=col and the base classes" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Camper")).to_html.strip

    assert_equal('<th scope="col" class="p-2 font-medium">Camper</th>', actual)
  end

  test "adds a centered alignment class" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Status", align: :center)).to_html

    assert_includes(actual, "text-center")
  end

  test "adds a right alignment class" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Amount", align: :right)).to_html

    assert_includes(actual, "text-right")
  end

  test "does not add an alignment class for the default left alignment" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Camper")).to_html

    assert_not_includes(actual, "text-left")
  end

  test "merges the width class into the header classes" do
    actual = render_inline(AtomicView::Components::TableComponent::ColumnComponent.new(label: "Camper", width: "w-32")).to_html

    assert_includes(actual, "w-32")
  end
end

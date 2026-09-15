# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::TableComponent::RowComponentTest < ViewComponent::TestCase
  test "renders a tr wrapping each with_cell" do
    booking = Booking.new(camper_name: "Karen Wilson")
    actual = render_inline(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: "Karen Wilson", path: "/bookings/1")) { |row|
      row.with_cell { "Karen Wilson" }
      row.with_cell { "Active" }
    }.to_html

    assert_includes(actual, "<tr")
    assert_includes(actual, "Karen Wilson")
    assert_includes(actual, "Active")
  end

  test "renders standalone with no parent TableComponent" do
    booking = Booking.new(camper_name: "Karen Wilson")
    actual = render_inline(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: "Karen Wilson", path: "/bookings/1")) { |row|
      row.with_cell { "Karen Wilson" }
    }.to_html

    assert_includes(actual, "<tr")
    assert_includes(actual, "<td")
  end

  test "defaults path to the record itself" do
    component = AtomicView::Components::TableComponent::RowComponent.new(record: :the_record, label: "Label")

    assert_equal(:the_record, component.path)
  end

  test "gives only the first cell's link a tabindex of 0" do
    booking = Booking.new(camper_name: "Karen Wilson")
    actual = render_inline(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: "Karen Wilson", path: "/bookings/1")) { |row|
      row.with_cell { "Karen Wilson" }
      row.with_cell { "Active" }
    }.to_html

    assert_includes(actual, 'tabindex="0"')
    assert_includes(actual, 'tabindex="-1"')
  end

  test "renders plain unlinked cells when clickable is false" do
    booking = Booking.new(camper_name: "Karen Wilson")
    actual = render_inline(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: "Karen Wilson", path: "/bookings/1", clickable: false)) { |row|
      row.with_cell { "Karen Wilson" }
    }.to_html

    assert_not_includes(actual, "<a")
    assert_not_includes(actual, "hover:bg-offset")
  end

  test "merges custom class and forwards other options" do
    booking = Booking.new(camper_name: "Karen Wilson")
    actual = render_inline(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: "Karen Wilson", path: "/bookings/1", class: "custom-row", id: "booking_1")) { |row|
      row.with_cell { "Karen Wilson" }
    }.to_html

    assert_includes(actual, "custom-row")
    assert_includes(actual, 'id="booking_1"')
  end
end

# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :site, null: false, foreign_key: true
      t.string :camper_name, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :bookings, %i[starts_on ends_on]
  end
end

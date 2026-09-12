# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :code, null: false
      t.string :park_name, null: false

      t.timestamps
    end

    add_index :sites, %i[code id], unique: true
  end
end

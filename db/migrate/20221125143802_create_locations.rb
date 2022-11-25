class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
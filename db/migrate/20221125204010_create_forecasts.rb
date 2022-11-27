class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.belongs_to :location, null: false
      t.text :latest

      t.timestamps
    end
  end
end

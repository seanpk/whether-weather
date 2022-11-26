class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.references :location, null: false, foreign_key: true
      t.text :latest

      t.timestamps
    end
  end
end

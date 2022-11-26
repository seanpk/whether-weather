class AddUniqueLocationColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :uuid, :string
    add_index :locations, :uuid, unique: true
  end
end

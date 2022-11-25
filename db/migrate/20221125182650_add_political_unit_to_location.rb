class AddPoliticalUnitToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :political_unit, :string
  end
end

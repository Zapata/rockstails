class CreateCompositions < ActiveRecord::Migration
  def self.up
    create_table :compositions do |t|
      t.integer :cocktail_id, :null => false
      t.integer :ingredient_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :compositions
  end
end

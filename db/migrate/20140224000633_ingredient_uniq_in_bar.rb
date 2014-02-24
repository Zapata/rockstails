class IngredientUniqInBar < ActiveRecord::Migration
  def change
    add_index :bars_ingredients, [:bar_id, :ingredient_id], unique: true
  end
end

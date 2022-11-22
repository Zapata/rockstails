class Bars < ActiveRecord::Migration[6.1]
  def change
    create_table :bars do |t|
      t.string :name, limit: 100, null: false
    end
    add_index :bars, :name, unique: true

    create_table :bars_ingredients, id: false do |t|
      t.integer :bar_id
      t.integer :ingredient_id
    end
    add_index :bars_ingredients, :bar_id
  end
end

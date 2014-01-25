class Cocktails < ActiveRecord::Migration
  def change    
    create_table :cocktails do |t|
      t.string :name, limit: 100, null: false
      t.text :method, null: false
      t.decimal :rate, precision: 2, scale: 1, null: true
      t.string :garnish, limit: 250, null: true
      t.string :glass, limit: 50, null: true
      t.text :comment, null: true
      t.text :aka, limit: 100, null: true
      t.text :variant, limit: 250, null: true
      t.text :origin, null: true
      t.string :source, limit: 250, null: false
      t.timestamps
    end
    add_index :cocktails, :name, unique: true

    create_table :ingredients do |t|
      t.string :name, limit: 100, null: false
    end
    add_index :ingredients, :name, unique: true
    
    create_table :recipe_steps do |t|
      t.belongs_to :cocktail
      t.belongs_to :ingredient
      t.integer :position, limit: 4
      t.string :amount, limit: 10, null: false
      t.string :doze, limit: 30, null: false
    end
    add_index :recipe_steps, [ :cocktail_id, :ingredient_id ], unique: true
  end
end

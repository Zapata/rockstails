class CreateCocktails < ActiveRecord::Migration
  def self.up
    create_table :cocktails do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :cocktails
  end
end

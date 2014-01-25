class Ingredient < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
  has_many :cocktails, through: :recipe_steps
end
class Composition
  include MongoMapper::EmbeddedDocument

  key :amount, String, :require => true
  key :doze, String

  belongs_to :ingredient
  key :ingredient_id, ObjectId, :require => true
end


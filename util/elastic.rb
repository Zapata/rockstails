require 'elasticsearch'
require 'yaml'
require 'json'
require 'pp'
require 'jbuilder'
require 'hashie'

require_relative '../model/dirty_cocktail'

@client = Elasticsearch::Client.new log: false

def load_cocktails
  puts 'Initialize cocktail database.'
  if @client.indices.exists index: 'cocktails' 
    puts "Data already present, let's do a reset."
    @client.indices.delete index: 'cocktails'
  end
  
  
  @client.indices.create index: 'cocktails', body: {
    mappings: {
      cocktail: {
        dynamic_templates: [
          {
            no_analysis: {
              match: '*',
              mapping: {
                index: 'no'
              }
            }
          }
        ],
        properties: {
          name: {
            type: 'string',
            index: 'analyzed'
          },
          recipe: {
            properties: {
              ingredient: {
                type: 'multi_field',
                fields: {
                  indexed: {
                    type: 'string',
                    index: "analyzed"
                  },
                  untouched: {
                    type: 'string', 
                    index: "not_analyzed"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  Dir['../db/*.yml'].each do |f|
    cocktail = YAML::load_file(f)
    puts "Loading: #{cocktail.name}"
    
    json = Jbuilder.encode do |json|
      json.name cocktail.name
      json.garnish cocktail.garnish
      json.glass cocktail.glass
      json.method cocktail.method
      json.infos cocktail.infos.reject {|key, value| key == 'source'}
      json.source cocktail.infos['source']
      json.rate cocktail.rate
      json.recipe cocktail.ingredients do |ingredient|
        json.quantity ingredient[DirtyCocktail::IDX_AMOUNT].strip
        json.doze ingredient[DirtyCocktail::IDX_DOZE].strip
        json.ingredient ingredient[DirtyCocktail::IDX_INGREDIENT]
      end
    end
    
    @client.index  index: 'cocktails', type: 'cocktail', id: cocktail.name, body: json
  end

  

end

def search(words)
  query = {
    fields: [
      "name", "recipe.ingredient"
    ], 
    query: {
      query_string: {
        fields: [ 'name^2', 'recipe.ingredient.indexed'], 
        query: words,
        default_operator: 'AND'
      }
    }, 
    size: 3000,
    sort: [
      {
        _score: {
          order: 'desc'
        }
      }
    ]
  }
  puts JSON.pretty_generate(query)
  @client.search index: 'cocktails', body: query
end


def list_ingredients()
  response = @client.search index: 'cocktails', body: {
    size: 0,
    query: {
      match_all: {
      }
    },
    facets: {
      tag: {
          terms: {
              field: 'recipe.ingredient.untouched',
              global: true,
              size: 1000
          }
      }
    }
  }
  mash = Hashie::Mash.new response
  mash.facets.tag.terms.collect { |e| "#{e.term} (#{e[:count]})" }
end

#load_cocktails
search('Yellow')
#puts list_ingredients()

# Add Bar filter.
# Add suggestions.
# Not searcheble by default?


# Optimized index: size = 4,12 MB (4 326 682 bytes)  / on disk: 9,31 MB (9 764 864 bytes)
# Unoptimized index: size = 4,68 MB (4 911 339 bytes) / on disk: 7,84 MB (8 224 768 bytes)

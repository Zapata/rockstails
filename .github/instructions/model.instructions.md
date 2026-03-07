---
applyTo: "model/**/*.rb"
description: "Model and DB layer conventions for Rock's Tails"
---

# Model Conventions

## DB Interface

- New DB backends must include the `InMemoryDB` mixin (`model/in_memory_db.rb`), which provides the shared search interface used by routes.
- `FileDB` handles YAML-backed storage; `ActiveRecordDB` handles PostgreSQL via ActiveRecord.
- `HybridDB` composes both: cocktails from YAML, bars from SQL. Use `extend Forwardable` + `def_delegators` to delegate methods cleanly.

## Adding a New Feature to the DB Layer

1. Define the method contract in `InMemoryDB` (or as a documented interface).
2. Implement it in both `FileDB` and `ActiveRecordDB`.
3. Delegate from `HybridDB` to the appropriate backend.
4. Add a shared test in `test/db_search_test.rb` via the `SearchInDBTest` module.

## ActiveRecord Models

Located in `model/activerecord/`. Each model maps to a DB table:
- `Bar` — named ingredient lists
- `Cocktail` — cocktail recipes
- `Ingredient` — ingredient names
- `RecipeStep` — steps linking cocktails and ingredients

Migrations live in `db/migrate/`. Always create a migration for schema changes; never alter the schema manually.

## Criteria

`Criteria` (`model/criteria.rb`) parses a shell-quoted search string:
- Plain words → search keywords matched against cocktail names and ingredients.
- `+ingredient` → temporarily add ingredient to the selected bar context.
- `-ingredient` → temporarily remove ingredient from the selected bar context.

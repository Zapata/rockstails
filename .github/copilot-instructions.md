# Rock's Tails — Copilot Instructions

## Project Overview

Rock's Tails is a Sinatra-based cocktail search web application written in Ruby 3.1+.
It lets users search for cocktails by ingredient keywords, manage personal bars (ingredient lists), and view stats.

## Tech Stack

- **Web framework**: Sinatra (`web.rb` is the entry point)
- **Views**: Haml (in `views/`)
- **CSS**: Bootstrap + custom styles (in `public/css/`)
- **Testing**: `test-unit` gem, all test files in `test/`
- **Deployment**: Fly.io (`fly.toml`, `config.ru`)

## Database Architecture

The app supports two backends, auto-detected at startup via the `DATABASE_URL` env var:

| Backend | Class | When used |
|---------|-------|-----------|
| File (YAML) | `FileDB` (`model/file/file_db.rb`) | No `DATABASE_URL` set |
| PostgreSQL via ActiveRecord | `ActiveRecordDB` (`model/activerecord/active_record_db.rb`) | `DATABASE_URL` is set |
| Hybrid | `HybridDB` (`model/hybrid_db.rb`) | Wraps both: cocktails from YAML, bars from SQL |

- Migrations are in `db/migrate/`
- Data files (cocktails, bars) are in `datas/`
- AR models: `model/activerecord/` (Bar, Cocktail, Ingredient, RecipeStep)
- InMemoryDB mixin (`model/in_memory_db.rb`) provides the shared search interface

## Key Conventions

- **Search**: `Criteria` class (`model/criteria.rb`) parses shell-quoted keyword strings; `+ingredient` includes, `-ingredient` excludes from the bar context.
- **Bar**: a named list of available ingredients, stored in YAML (`datas/bar/*.yml`) or PostgreSQL.
- **Stats**: `BarStats` / `BarStatsCalculator` compute ingredient coverage metrics.
- **IngredientManager**: handles renaming/aliasing ingredients (`datas/ingredients_rename.csv`).

## Development Workflow

```bash
# Run all tests
rake test

# Start the app locally (file backend)
ruby web.rb           # or: rackup

# Database setup (PostgreSQL backend)
rake db:migrate db:import_ingredients db:import_cocktails db:import_bars

# Local Postgres on Ubuntu
sudo systemctl start postgresql.service

# Connect to production DB (Fly.io)
flyctl proxy 15432:5432 -a rockstails-db
DATABASE_URL=postgres://rocktails:<password>@localhost:15432/rockstails rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
fly deploy
```

Default local DB credentials: `postgres://rockstails:pass@localhost/rockstails`

## Testing Guidelines

- Test files follow the `*_test.rb` naming convention under `test/`.
- Use `Test::Unit::TestCase` as base class.
- Shared test behaviour is extracted into modules (e.g., `SearchInDBTest` in `test/db_search_test.rb`).
- Both `FileDB` and `ActiveRecordDB` share the same search tests via the mixin.
- Run a single test file: `ruby -Itest test/<file>_test.rb`

## Code Style

- Ruby standard style: 2-space indentation, snake_case methods/variables, CamelCase classes.
- Keep Sinatra routes thin — delegate logic to model/db classes.
- Prefer `require_relative` for local files.
- Do not add gems without updating `Gemfile`.

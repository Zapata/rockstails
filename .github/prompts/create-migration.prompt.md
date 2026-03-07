---
mode: agent
description: "Create a new ActiveRecord migration for Rock's Tails schema changes"
---

# Create a Migration

Generate and apply an ActiveRecord migration for a Rock's Tails schema change.

## Inputs

- **Migration name**: ${input:migrationName:e.g. add_rating_to_cocktails}
- **Description**: ${input:description:What schema change this migration makes}

## Steps

1. Create a new migration file in `db/migrate/` with a timestamp prefix (`YYYYMMDDHHmmss_<migrationName>.rb`).
2. Follow the patterns in existing migrations (e.g. `db/migrate/20131222212055_cocktails.rb`).
3. Implement `change` (or `up`/`down`) using ActiveRecord DSL.
4. Update the corresponding AR model in `model/activerecord/` if column changes affect the model.
5. Run `rake db:migrate` to apply, then verify with `rake test` (requires local Postgres running).

## Local DB

```bash
sudo systemctl start postgresql.service   # Ubuntu
rake db:migrate
rake test
```

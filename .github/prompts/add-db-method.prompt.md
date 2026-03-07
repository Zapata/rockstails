---
mode: agent
description: "Add a new DB method to both FileDB and ActiveRecordDB backends, with tests"
---

# Add a DB Method

Implement a new method on both DB backends so it is available through the full DB stack.

## Inputs

- **Method signature**: ${input:methodSignature:e.g. def top_cocktails(limit)}
- **Purpose**: ${input:purpose:What this method returns or does}

## Steps

1. Read `model/in_memory_db.rb` — add the method contract (comment or abstract-style method) here.
2. Implement the method in `model/file/file_db.rb` using in-memory YAML data.
3. Implement the method in `model/activerecord/active_record_db.rb` using ActiveRecord queries.
4. Delegate from `model/hybrid_db.rb` to the correct backend via `def_delegators`.
5. Add a shared test case in `test/db_search_test.rb` inside the `SearchInDBTest` module.
6. Run `rake test` to verify both backends pass.

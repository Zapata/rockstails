---
applyTo: "test/**/*.rb"
description: "Test conventions for Rock's Tails using test-unit"
---

# Test Conventions

- Always use `Test::Unit::TestCase` as the base class.
- Extract shared behaviours into modules included in test classes (see `test/db_search_test.rb`).
- Use `def self.startup` for expensive one-time setup (e.g. DB connections) instead of `setup`.
- Use `def setup` only for lightweight per-test state.
- Name test methods descriptively: `test_<scenario>`.
- Do not mock the DB backends; use the real `FileDB` for unit tests and the real `ActiveRecordDB` for integration tests.
- Run a single file with: `ruby -Itest test/<file>_test.rb`
- Run all tests with: `rake test`

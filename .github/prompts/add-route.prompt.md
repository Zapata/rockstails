---
mode: agent
description: "Add a new Sinatra route and its Haml view to Rock's Tails"
---

# Add a New Route

Add a new Sinatra route and its corresponding Haml view to the Rock's Tails application.

## Inputs

- **Route path**: ${input:routePath:e.g. /cocktails/trending}
- **Feature description**: ${input:featureDescription:What this route does}

## Steps

1. Read `web.rb` to understand the existing route patterns and helpers.
2. Add the new route to `web.rb`, delegating logic to the model/DB layer where needed.
3. Create a new Haml view in `views/` following the conventions in existing views (e.g. `views/list.haml`).
4. Ensure the layout (`views/layout.haml`) is inherited via `haml :view_name`.
5. Add any required navigation links to `views/layout.haml`.
6. Run `ruby web.rb` mentally or note how to test this manually.

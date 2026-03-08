
# Rock's Tails

Easily find a tasty cocktail to mix.

Visit [https://rockstails.fly.dev/](https://rockstails.fly.dev/) to try!

## Tech Stack

- **Language**: Ruby 4.0.1+
- **Web framework**: Sinatra (`web.rb` is the entry point)
- **Views**: Haml
- **CSS**: Bootstrap + custom styles
- **Testing**: `test-unit` gem — all test files in `test/`
- **Deployment**: Fly.io

## Database Backends

The app auto-detects the backend at startup via the `DATABASE_URL` environment variable:

| Mode | When used | Notes |
|------|-----------|-------|
| File (YAML) | `DATABASE_URL` not set | `FileDB` — reads cocktails and bars from `datas/` |
| Hybrid | `DATABASE_URL` is set | `HybridDB` — cocktails from YAML, bars in PostgreSQL |

## Setup

### Local — File backend (no database required)

1. Install Ruby 4.0.1+ and Bundler.
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Start the app:
   ```bash
   ruby web.rb   # or: rackup
   ```
4. Visit [http://localhost:8080](http://localhost:8080).

### Local — PostgreSQL backend

1. Install and start PostgreSQL. On macOS: `brew services start postgresql`.  
   On Ubuntu: `sudo systemctl start postgresql.service`.

2. Create the database and user:
   ```bash
   sudo -u postgres createuser rockstails
   sudo -u postgres createdb rockstails
   sudo -u postgres psql
   postgres=# ALTER USER rockstails WITH ENCRYPTED PASSWORD 'pass';
   postgres=# GRANT ALL PRIVILEGES ON DATABASE rockstails TO rockstails;
   ```

3. Run migrations and import data:
   ```bash
   rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
   ```

4. Run tests:
   ```bash
   rake test
   ```

5. Start the app:
   ```bash
   ruby web.rb
   ```

6. Visit [http://localhost:8080](http://localhost:8080).

Default local DB URL: `postgres://rockstails:pass@localhost/rockstails` (used automatically by the `Rakefile`).

### Docker

1. Build and start containers:
   ```bash
   docker-compose up --build
   ```

2. Run migrations and import data:
   ```bash
   docker-compose run --rm app rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
   ```

3. Run the test suite:
   ```bash
   docker-compose run --rm app rake test
   ```

4. Access the app at [http://localhost:8080](http://localhost:8080).

5. Stop containers:
   ```bash
   docker-compose down
   ```

## Rake Tasks

| Task | Description |
|------|-------------|
| `rake test` | Run the full test suite |
| `rake db:migrate` | Run database migrations |
| `rake db:import_ingredients` | Import ingredients from `datas/cocktails.yml` into the database |
| `rake db:import_cocktails` | Import cocktails from `datas/cocktails.yml` into the database |
| `rake db:import_bars` | Import bars from `datas/bar/` into the database |
| `rake db:export_cocktails` | Export cocktails from the database back to `datas/cocktails.yml` |
| `rake db:export_bars` | Export bars from the database back to `datas/bar/` |

> All `db:import_*` and `db:export_*` tasks respect the `DATABASE_URL` environment variable.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DATABASE_URL` | _(none)_ | PostgreSQL connection URL. When set, the hybrid backend is used (bars in SQL, cocktails from YAML). When unset, the file backend is used. |
| `APP_ENV` | `default_env` | Rack environment (`development`, `production`, etc.). |
| `PORT` | `8080` | Port the app listens on. |

## Deployment (Fly.io)

1. Proxy to the production database:
   ```bash
   flyctl proxy 15432:5432 -a rockstails-db
   ```

2. Migrate and import data into production:
   ```bash
   DATABASE_URL=postgres://rockstails:<password>@localhost:15432/rockstails rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
   ```

3. Deploy:
   ```bash
   fly deploy
   ```

## Running GitHub Actions Locally (act)

You can use [act](https://github.com/nektos/act) to run GitHub Actions locally. Requires Docker.

```bash
brew install act
act              # run default workflow
act -e push      # simulate a push event
act -j <job>     # run a specific job
```

Or run `act` in a container without installing it:

```bash
docker run --rm \
  -v $(pwd):/github/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/nektos/act:latest
```

## Thanks

Simon Difford and [http://www.diffordsguide.com](http://www.diffordsguide.com)
for his extensive cocktail database.


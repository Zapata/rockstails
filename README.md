Rock's Tails
============

# Dummy commit for PR 24 branch protection update

Website
-------

Easely find a tasty cocktail to mix.

Visit [http://rockstails.herokuapp.com/](http://rockstails.herokuapp.com/) to try!


Technical stuff
---------------

- Run on (J)ruby.
- Build with Sinatra, Haml, Yaml Bootstrap and JQuery.
- Cocktail database in Yaml from Difford's website.

Installation
------------

1. Install postgres
2. Create a rockstails database with a rockstails/pass user.
3. run `rake db:migrate db:import_cocktails db:import_bars`
4. `rake test` should work.
5. `ruby web.rb` (or `rackup`) will start the application on http://localhost:4567/


Usage:
------

At startup it will autodetect if a database is configured or not (using DATABASE_URL env variable).
If not it will use an in-memory databse.

To start Postgres locally on Ubuntu use: `sudo systemctl start postgresql.service`
To create the user/db for test: 

```
sudo -u postgres createuser rockstails
sudo -u postgres createdb rockstails
sudo -u postgres psql
postgres=# alter user rockstails with encrypted password 'pass';
postgres=# grant all privileges on database rockstails to rockstails ;
rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
```

To deploy it:

```
flyctl proxy 15432:5432 -a rockstails-db
DATABASE_URL=postgres://rocktails:<password>@localhost:15432/rockstails rake db:migrate db:import_ingredients db:import_cocktails db:import_bars
fly deploy
```


Thanks
------

Simon Difford's and [http://www.diffordsguide.com](http://www.diffordsguide.com) 
for his extensive cocktail database (but messy site).

# Quick Start (Docker)

1. Build and start containers:

    docker-compose up --build

2. Run Rake tasks (e.g., migrations, tests):

    docker-compose run --rm app rake test
    docker-compose run --rm app rake db:migrate

3. Run Ruby scripts:

    docker-compose run --rm app ruby util/bench.rb

4. Access the app:

    http://localhost:4567

5. Stop containers:

    docker-compose down

## Running GitHub Actions Locally (act)

You can use [act](https://github.com/nektos/act) to run GitHub Actions locally. Make sure Docker is running.

1. Install act:

    brew install act

2. Run a workflow (example: test):

    act

3. For custom events or jobs:

    act -e push
    act -j <job-name>

4. All actions run inside Docker containers, so no Ruby or Rake is needed on your host.

### Containerized act (no install required)

You can run act in a container without installing it:

    docker run --rm \
      -v $(pwd):/github/workspace \
      -v /var/run/docker.sock:/var/run/docker.sock \
      ghcr.io/nektos/act:latest

This mounts your project and Docker socket, so act can run workflows as if on your host.

- To run a specific event:

    docker run --rm -v $(pwd):/github/workspace -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/nektos/act:latest -e push

- To run a specific job:

    docker run --rm -v $(pwd):/github/workspace -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/nektos/act:latest -j <job-name>


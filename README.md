Rock's Tails
============

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
5. `ruby web.rb` will start the application on http://localhost:4567/

Thanks
------

Simon Difford's and [http://www.diffordsguide.com](http://www.diffordsguide.com) 
for his extensive cocktail database (but messy site).


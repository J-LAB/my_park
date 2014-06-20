trail_buddy
===========

J-LAB's entry for Philly EcoCamp 

# Dependencies:
  * Ruby 2.1.1
  * GEOS
  * PostgreSQL
  * PostGIS

# Setup:
  set local ruby version if using rbenv:

    rbenv local 2.1.1

  generate rails app in current dir:

    rails new . -T  --database=postgresql

  edit the gemfile:

    vim Gemfile

      uncomment "gem 'therubyracer',  platforms: :ruby"

      add the following:

        gem 'activerecord-postgis-adapter'
        gem 'bootstrap-sass'
        gem 'dbf'
        gem 'execjs'
        gem 'haml'
        gem 'haml-rails'
        gem 'rgeo'
        gem 'rgeo-geojson'

        group :development, :test do
          gem 'awesome_print'
          gem 'factory_girl_rails'
          gem 'faker'
          gem 'guard-rspec'
          gem "pry"
          gem 'rspec-rails'
          gem 'spring-commands-rspec'
        end

  install gems:

    bundle install

  edit application config to use postgis:

    vim config/application.rb

      add "require 'active_record/connection_adapters/postgis_adapter/railtie'"

  update database.yml to use postgis:

    vim config/database.yml

      in the default env

        change adapter to 'postgis'

        add 'schema_search_path: "public,postgis"'

      in test and dev env

        add "script_dir: <PATH_TO_POSTGIS>"

        ex "script_dir: /usr/share/postgresql/9.2/contrib/postgis-2.1"

  create the db:

    rake db:create

  create binstubs for spring:

    spring binstub --all

  setup rspec:

    rails g rspec:install

  initialize guard:

    guard init

  setup guard to use spring:

    vim Guardfile

      change line "guard :rspec do" to 'guard :rspec, cmd:"spring rspec" do'

  require bootstrap in application.js and application.css:

    vim app/assets/javascripts/application.js

      add '//= require bootstrap'

    vim app/assets/stylesheets/application.css

      add '@import "bootstrap";'

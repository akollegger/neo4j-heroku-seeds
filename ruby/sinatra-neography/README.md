Neo4j on Heroku with Sinatra using Neography
============================================

This is an example application for our [Neo4j Add-On](https://addons.heroku.com/marketplace/neo4j) on Heroku.

## Clone, Build and Go!

1. Get Neo4j
   * (Download Neo4j)[http://neo4j.org/download]
   * Follow Neo4j's README to start the database
   * Make sure it is running by browsing Neo4j's (Web Interface)[http://localhost:7474]
2. Run the seed app locally
   * `git clone https://github.com/akollegger/neo4j-heroku-seeds.git`
   * `cd neo4j-heroku-seeds/ruby/sinatra-neography`
   * `bundle install`

## Deploying to Heroku

1. Get Heroku
   * create an account on (Heroku)[http://heroku.com]
   * get the (Heroku Toolbelt)[https://toolbelt.heroku.com]
2. Heroku'ify the seed application
   * `git init`
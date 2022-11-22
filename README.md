# SaS

Sas is a Ruby on Rails based CRM solution. Sas includes customer ticketing, basic accounting, and customer management.
Sas resource usage is relatively low and can run on a variety of hardware or in a container.
Sas has not been subject to extensive vulnerability testing, and I would not recommend running SaS on a public network.

## Ruby version
7 (Originally 4 or 5)

## System dependencies
- node.js
- libvips
- ruby 3+
- MariaDB/MySQL
- Apache httpd
- Maybe more

## Testing dependencies
- Selenium web driver
- Chrome or Chromium

## Configuration
- Read db/seeds.rb
- replace assets/images/logos/corp_logo.png
    - This image is used for branding
- Change every instance of the case sensitive text "REMOVED" to appropriate values. They are mostly redactions of private test data and app secrets.
- install libvips, mariadb/mysql, and maybe a few others.
-  Install Ruby 3+ and Rails 7ish
- bundle install
    - MySQL/Maria/VIPS may cause errors, here, install libraries.
- Fix db/seeds.rb
    - You may wish to enter some more basic values, 99% of them can be added any time.
- Configure active storage and ensure data sources exist
- Configure databases. built for MySQL/MariaDB, not tested on any other software.
- Read Gemfile and package.json
    - Give some love to those dependencies.
- At some point, a yarn install is needed.
- bash exec rails db:create
    - may need to db:seed
- bash exec RAILS_ENV='test' rails db:create
    - may need to db:seed
- rails test
    - Some Selenium tests may fail due to an unresolved timing issue. Who's fault? Probably mine.
- There's a helper script for dev bin/serve
- if all is well, feel free to deploy production
    - you'll want to precompile assets
    - Internally we deploy with phusionpassenger and Apache2
    - work may be needed to adopt to cloud.
- Sas can be run in a Docker container.
    - Sorry, we don't have an up to date Dockerfile.

## Database creation
rails db:create

## Database initialization
rails db:migrate

## How to run the test suite
rails test

## Deployment instructions
rails assets:precompile

### Version info is in app/lib/version/version.rb 

#### Copyright 2015-2022 Matthew Petricone


# Installation instructions (new server)

1.  Clone from git repo.

2.  Install Ruby & Rails through RVM:

        \curl -L https://get.rvm.io | bash -s stable --autolibs=3 --rails

3.  Add RVM initialisation to bashrc (so that you get the PATH to RVM binaries/tools):

        echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc

4.  Install Gem dependencies:

        bundle install --deployment

5.  If 4. doesn't work. Try installing Ruby 1.9.3:

        rvm install ruby-1.9.3
        rvm --default use 1.9.3

6.  You'll maybe need these dependencies:

        apt-get -y install libpq-dev build-essential libcurl4-openssl-dev apache2-mpm-prefork apache2-prefork-dev libapr1-dev libaprutil1-dev

7.  PostgreSQL:

        apt-get -y install postgresql

8.  Passenger (instructions: https://www.phusionpassenger.com/download):

        gem install passenger
        cd ~
        passenger-install-apache2-module

9.  Configure Apache (so that passenger will run). Add this to '/etc/apache2/sites-enabled/000-default':

        <VirtualHost *:80>
            ServerName dev.trainerjim.com

            DocumentRoot "/maco/rails/apps/trainerjimserver/public"
            <Directory "/maco/rails/apps/trainerjimserver/public">
                AllowOverride all
                Options -MultiViews
                AuthType None
                Order deny,allow
                Allow from all
            </Directory>

            <LocationMatch "^/assets/.*$">
                Header unset ETag
                FileETag None
                ExpiresActive On
                ExpiresDefault "access plus 1 year"
                Header append Cache-Control public
            </LocationMatch>
        </VirtualHost>

    And this to '/etc/apache2/apache2.conf' (before sites-enabled is included):

        LoadModule passenger_module /usr/local/rvm/gems/ruby-1.9.3-p392/gems/passenger-3.0.19/ext/apache2/mod_passenger.so
        PassengerRoot /usr/local/rvm/gems/ruby-1.9.3-p392/gems/passenger-3.0.19
        PassengerRuby /usr/local/rvm/wrappers/ruby-1.9.3-p392/ruby

    In apache enable the mod_headers module:

        cd /etc/apache2/mods-enabled/
        ln -s ../mods-available/headers.load .
        ln -s ../mods-available/expires.load .

10. Configure PgSQL:

    Create the `trainerjim` user (with password `trainerjim`):

        CREATE ROLE trainerjim LOGIN
            ENCRYPTED PASSWORD 'md53cc7cd3df4abff9c7954bcd4979cea67'
            SUPERUSER INHERIT CREATEDB NOCREATEROLE REPLICATION;

11. Finally set up the application:

        bundle exec rake db:setup RAILS_ENV=production

12. Whenever you want to update the app, run something like this:

        cd /maco/rails/apps/trainerjimserver && git pull && bundle exec rake db:migrate assets:precompile RAILS_ENV=production && touch /maco/rails/apps/trainerjimserver/tmp/restart.txt

# Deployment

Targets: localdev, dev, staging, or production

    cap <target> deploy

On first deployment run:

    cap <target> deploy:setup

# Database

## Dumping the database

    pg_dump -C -h localhost -U trainerjim trainerjim_production > "trainerjim_production.$(date '+%Y-%m-%d-%H%M').sql"

## Restoring the database

    psql -U trainerjim -h localhost postgres < the_dump.sql

# RVM

## Updating RVM

    rvm get stable

## Updating Ruby

    rvm upgrade ruby-1.9.3-p392 ruby-1.9.3-p429

## Updating Passenger

    gem install passenger && passenger-install-apache2-module

Then update the 'vim /etc/httpd/conf.d/passenger.conf' file (or another Apach HTTPD configuration file, where you store your Passenger config).
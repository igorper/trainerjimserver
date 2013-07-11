# Day-to-day development

## Re-seed the database

Locally:

    rake db:truncate db:bootstrap db:seed

Remotely:

    cap <deployment_target> do:invoke task="db:truncate db:bootstrap db:seed"

For a list of deployment targets see files in directory `config/deploy`.

## Open Rails console remotely

    cap <deployment_target> rails:console

## Running tests

    rake test

## Deployment

Whenever you update your local repository, commit to your local master and run:

    cap localdev deploy

This will update your local server, which you can access through `http://localhost/`.

Before opening a _pull request_, push your changes to the `master` branch in your Bitbucket remote. Afterwards run:

    cap <your_name> deploy

This will deploy your changes to the site `http://<your_name>.trainerjim.com/`.

When you deploy for the first time, do the following:

    cap <target> deploy:bootstrap

For a list of deployment `<targets>` see `config/deploy` (every file in this directory is a target).

# Installation instructions (new server)

1.  Clone from git repo.

2.  Install Ruby & Rails through RVM:

        \curl -L https://get.rvm.io | sudo bash -s stable --auto-dotfiles

3.  Install the stable Ruby:

        rvm install 2.0.0

    Select the default Ruby:

        rvm use --default 2.0.0

    You can list available Ruby versions with:

        rvm list known


Afterwards, for every update deployment you must call:

    cap <target> deploy
4.  PostgreSQL:

        apt-get -y install postgresql

    Create the `trainerjim` user (with password `trainerjim`):

        sudo su postgres
        psql
        CREATE ROLE trainerjim LOGIN
            ENCRYPTED PASSWORD 'md53cc7cd3df4abff9c7954bcd4979cea67'
            SUPERUSER INHERIT CREATEDB NOCREATEROLE REPLICATION;

5.  Passenger (instructions: [https://www.phusionpassenger.com/download]):

        gem install passenger
        cd ~
        passenger-install-apache2-module

    Passenger will instruct you about what you have to put into the Apache config file `/etc/apache2/apache2.conf`.

6.  Enable the following Apache mods:

        cd /etc/apache2/mods-enabled/
        ln -s ../mods-available/headers.load .
        ln -s ../mods-available/expires.load .

7.  Tell Apache where our app will be deployed. Add this to `/etc/apache2/sites-enabled/000-default`:

        <VirtualHost *:80>
        #    ServerName dev.trainerjim.com
        #    ServerAlias jim.fzv.uni-mb.si

            DocumentRoot "/maco/rails/deployments/TrainerJim/localdev/current/public"
            RackEnv "localdev"

            <Directory "/maco/rails/deployments/TrainerJim/localdev/current/public">
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

8.  Set up the application:

        rake db:create db:migrate db:bootstrap

9.  Deploy the app whenever you want to update a site (see section `Deployment`).

# Database

## Dumping the database

    pg_dump -C --quote-all-identifiers -h localhost -U trainerjim trainerjim_production > "trainerjim_production.$(date '+%Y-%m-%d-%H%M').sql"

If you have trouble restoring the database because of bytea encoding, run this before dumping:

    ALTER DATABASE <your_db> SET bytea_output = 'escape';

## Restoring the database

    psql -U trainerjim -h localhost postgres < the_dump.sql

# Updating

## Updating RVM

    rvm get stable

## Updating Ruby

    rvm upgrade ruby-1.9.3-p392 ruby-1.9.3-p429

## Updating Passenger

    gem install passenger && passenger-install-apache2-module

Then update the `vim /etc/httpd/conf.d/passenger.conf` file (or another Apach HTTPD configuration file, where you store your Passenger config).

## Updating dependencies (Gems)

    bundle update

## Updating the OS of the production server

1.  Open a background shell (it will remain active even after you log out or if your connection drops):

        screen

2.  Run the update command:

        yum --skip-broken -y update

3.  You can detach the screen by pressing:

        Ctrl + a, d

4.  To close the screen, run:

        screen -r

    If there is more than one screen, you'll have to fetch a list of detached screens and kill the right one:

        screen -ls
        screen -r <pid.tty.host>

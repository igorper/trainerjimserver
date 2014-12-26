# Day-to-day development

## Open in IntelliJ

1. Select `Open project...`.

2. Find the `trainerjimserver` folder and open it.

## Add javascripts

1. Add a line like this to `Bowerfile`:

    ```ruby
    asset 'angular'
    ```
2. Run the following:

    ```bash
    bundle exec rake bower:install
    ```

## Re-seed the database

Locally:

    rake db:truncate db:bootstrap db:seed

Remotely:

    cap <deployment_target> do:invoke task="db:truncate db:bootstrap db:seed"

For a list of deployment targets see files in directory `config/deploy`.

## Open Rails console remotely

    cap <deployment_target> rails:console

## Running tests

    rake spec test

## Deployment

Whenever you update your local repository, commit to your local master and run:

    cap localdev deploy

This will update your local server, which you can access through `http://localhost/`.

Before opening a _pull request_, push your changes to the `master` branch in your personal Bitbucket remote. Afterwards run:

    cap <your_name> deploy

This will deploy your changes to the site `http://<your_name>.trainerjim.com/`.

When you deploy for the first time, do the following:

    cap <target> deploy:bootstrap

For a list of deployment `<targets>` see `config/deploy` (every file in this directory is a target).

To deploy to production, you must call:

    cap <target> deploy

# Installation instructions (new server)

1.  Clone from git repo.

2.  Install the stable Ruby (use [`rbenv`](https://github.com/sstephenson/rbenv)).

3.  PostgreSQL:

        apt-get -y install postgresql

    Create the `trainerjim` user (with password `trainerjim`):

        sudo su postgres
        psql
        CREATE ROLE trainerjim LOGIN
            ENCRYPTED PASSWORD 'md53cc7cd3df4abff9c7954bcd4979cea67'
            SUPERUSER INHERIT CREATEDB NOCREATEROLE REPLICATION;

4.  Set up the application:

        rake db:create db:migrate db:bootstrap

5.  Deploy the app whenever you want to update a site (see section `Deployment`).

# Database

## Dumping the database

    pg_dump -C --quote-all-identifiers -h localhost -U trainerjim trainerjim_production > "trainerjim_production.$(date '+%Y-%m-%d-%H%M').sql"

If you have trouble restoring the database because of bytea encoding, run this before dumping:

    ALTER DATABASE <your_db> SET bytea_output = 'escape';

## Restoring the database

    psql -U trainerjim -h localhost postgres < the_dump.sql
    
## Killing all existing database connections (needed to drop the database to reseed)

    psql -c "SELECT procpid, pg_terminate_backend(procpid) as terminated FROM pg_stat_activity WHERE procpid <> pg_backend_pid();" -d <database_name>

Use `sudo -u postgres <command>` to do this as root via ssh on production server.

# Updating

## Updating Ruby

    rvm get stable

## Updating Ruby

    See [rbenv](https://github.com/sstephenson/rbenv)

## Updating dependencies (Gems)

    bundle update

## Updating the OS of the production server

1.  Open a background shell (it will remain active even after you log out or if your connection drops):

        screen

2.  Run the update command:

        yum --skip-broken -y update

3.  You can detach the screen by pressing:

        Ctrl + a, d

4.  To reattach to a screen, run:

        screen -r

    If there is more than one screen, you'll have to fetch a list of detached screens and kill the right one:

        screen -ls
        screen -r <pid.tty.host>

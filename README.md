# Day-to-day development

## Open in IntelliJ

1. Select `Open project...`.

2. Find the `trainerjimserver` folder and open it.

## Add javascripts

1. Add a line like this to `Bowerfile`:

        #!ruby
        asset 'angular'

2. Run the following:

        #!bash
        bundle exec rake bower:install

## Create the production database

Here's how you can create the production database (but don't seed it, because it will send registration emails to the users):

    RAILS_ENV=production rake db:create db:migrate db:bootstrap

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

1. Install the ssh key for `trainerjim` on the production server.

2. Run the following command:

    ```
    bundle exec cap production deploy
    ```

3. Restart the server. Log in as sudoer, and run:

    ```
    sudo stop trainerjim; sudo start trainerjim
    ```

## Create your own deployment

1. Create your own copy of the following files:

        config/depoy/*-staging.rb // Make sure you change the deploy_to path and the repo_url
        config/environments/*-staging.rb // Make sure you change the port here (at the bottom of the file)
        deployment/*-trainerjim.conf // Make sure you change: PROGRAM_NAME, FULL_PATH, RAILS_PORT, and RAILS_ENV

2. Add a database entry for your environment into `config/database.yml`.

3. Run `bundle exec cap your-staging deploy` (it will fail because you have to first create a database).

4. Create a database for your deployment. SSH into the server, find the checkout of your deployment (from the previous step):

        sudo su - trainerjim
        cd /home/trainerjim/your-staging-trainerjimserver/releases/*
        RAILS_ENV=your-staging rake db:create

5. Put the `deployment/*-trainerjim.conf` script into the `/etc/init` folder.

6. Run step 3 again.

7. Try starting the server with `sudo start your-trainerjim`

# Installation instructions (new server)

Install dependencies:

* PostgreSQL:

    * Ubuntu: `sudo apt-get -y install postgresql`
    * Windows: `choco install postgresql93`
    * Create the `trainerjim` user (with password `trainerjim`):

            sudo su postgres
            psql
            CREATE ROLE trainerjim LOGIN
                ENCRYPTED PASSWORD 'md53cc7cd3df4abff9c7954bcd4979cea67'
                SUPERUSER INHERIT CREATEDB NOCREATEROLE REPLICATION;

* ImageMagick (for the PaperClip gem):

    * Ubuntu: `sudo apt-get install ImageMagick`
    * Windows: `choco install imagemagick.app`

* Windows only: install cygwin `choco install cygwin` and make sure `/c/tools/cygwin/bin` into your path.

* Install: `deployment/trainerjim.conf` into `/etc/init` and `deployment/10-trainerjim` into `/etc/sudoers.d/`

Repo preparation:

1.  Clone from git repo.

2.  Install the stable Ruby (use [`rbenv`](https://github.com/sstephenson/rbenv)).

3.  Set up the application:

        rake db:create db:migrate db:bootstrap

4.  Deploy the app whenever you want to update a site (see section `Deployment`).

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
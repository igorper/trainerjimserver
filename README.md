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

## Running JavaScript tests

1. Install Karma with `npm install -g karma-cli karma karma-jasmine karma-chrome-launcher`
1. Run `karma start`

## Create an on-boarding trainer account

SSH into the server. Log in as `trainerjim`. Navigate to `/home/trainerjim/trainerjimserver-cap/current`. Run `RAILS_ENV=staging rails c`.

```
load(Rails.application.root.join('lib/account_creation.rb'))
AccountCreation.create_trainer("trainer@example.com", "some password", "Full Name")
```

## Create the production database

Here's how you can create the production database (but don't seed it, because it will send registration emails to the users):

    RAILS_ENV=production bundle exec rake db:create db:migrate

## Re-seed the database

Locally:

    bundle exec rake db:truncate db:seed

Remotely:

    cap <deployment_target> do:invoke task="db:truncate db:seed"

For a list of deployment targets see files in directory `config/deploy`.

## Running tests

    rake spec test

## Deployment

1. Install the ssh key for `trainerjim` on the production server.

2. Run the following command:

    ```
    bundle exec cap production deploy
    ```

3. Restart the server:

    ```
    bundle exec cap production stop_server
    bundle exec cap production start_server
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
            CREATE ROLE trainerjim LOGIN ENCRYPTED PASSWORD 'md53cc7cd3df4abff9c7954bcd4979cea67' SUPERUSER INHERIT CREATEDB NOCREATEROLE REPLICATION;

* ImageMagick (for the PaperClip gem):

    * Ubuntu: `sudo apt-get install ImageMagick`
    * Windows: `choco install imagemagick.app`

* Windows only: install cygwin `choco install cygwin` and make sure `/c/tools/cygwin/bin` into your path.

* Install: `deployment/trainerjim.conf` into `/etc/init` and `deployment/10-trainerjim` into `/etc/sudoers.d/`

Repo preparation:

1.  Clone from git repo.

2.  Install the stable Ruby (use [`rbenv`](https://github.com/sstephenson/rbenv)).

3.  Set up the application:

        rake db:create db:migrate

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

# Tips and tricks

## Adding a photo through the Rails console

Start the Rails console:

```
rails c
```

Now run the following:

```
my_group = ExerciseGroup.first
my_group.photo = Rails.root.join('app/assets/images/logo_full.png').open()
my_group.save
```

# Symptoms and solutions

## Test fixtures throw ForeignKeyViolation

When running tests, I get the following exception:

```
UserTest#test_admin_trainer_roles:
ActiveRecord::InvalidForeignKey: PG::ForeignKeyViolation: ERROR:  insert or update on table "exercises" violates foreign key constraint "fk_rails_debbcb13c2"
DETAIL:  Key (training_id)=(1041130383) is not present in table "trainings".
: INSERT INTO "exercises" ("order", "created_at", "updated_at", "id", "training_id", "exercise_type_id") VALUES (100, '2015-08-01 10:00:43', '2015-08-01 10:00:43', 393439535, 1041130383, 651748134)
```

__Solution__: Look at [this solution](http://stackoverflow.com/questions/28046415/loading-rails-fixtures-in-a-specific-order-when-testing).


## Rails console in production server

Running ``bundle exec rails c`` produces the following exception:

```
/home/trainerjim/.rbenv/versions/2.1.5/lib/ruby/2.1.0/irb/completion.rb:9:in `require': cannot load such file -- readline (LoadError)
        from /home/trainerjim/.rbenv/versions/2.1.5/lib/ruby/2.1.0/irb/completion.rb:9:in `<top (required)>'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/console.rb:3:in `require'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/console.rb:3:in `<top (required)>'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/commands_tasks.rb:123:in `require'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/commands_tasks.rb:123:in `require_command!'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/commands_tasks.rb:58:in `console'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands/commands_tasks.rb:39:in `run_command!'
        from /home/trainerjim/trainerjimserver-cap/shared/bundle/ruby/2.1.0/gems/railties-4.2.1/lib/rails/commands.rb:17:in `<top (required)>'
        from bin/rails:6:in `require'
        from bin/rails:6:in `<main>'
```

__Solution__:

1. Invoke:

    ```
    sudo apt-get install libreadline-dev
    ```

2. Add the following line to `Gemfile`:

    ```
    gem 'rb-readline'
    ```
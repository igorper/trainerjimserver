# Customisation Instructions

1.  Set your Git username and email (user your full name and the email you use for Bitbucket):

        git config --global user.name "Matej Urbas"
        git config --global user.email matej.urbas@gmail.com

2.  Set up your ssh key:

        ssh-keygen

    and do the following sequence:

    1.  Press `enter` to select the default path for the generated key,

    2.  Now press `y`, to confirm that the key should be overwritten,

    3.  Finally press `enter` twice (if you don't want to enter a password when unlocking the private key).

    4.  The key should be generated. Copy it to the clipboard:

            xclip -sel clip < ~/.ssh/id_rsa.pub

3.  Now go to your Bitbucket account (click the top-right person icon and select `Manage Account`).

4.  Click `SSH keys` and `Add key`.

5.  Paste the key into the `Key` field and set the label to `trainerjim@devel-vm`.

6.  Go to the trainerjim development folder:

        cd ~/Programming/trainerjimserver

    And make the URL of the `origin` remote point to your personal repository (replace `<your username>` with your Bitbucket username):

        git remote set-url origin git@bitbucket.org:<your username>/trainerjimserver.git

# Developer's Guide

## TrainerJIM Server

-   __Sources__: Sources for the TrainerJIM server are located here:

        ~/Programming/trainerjimserver

-   __IDE__: To develop the server, use `NetBeans`. It is the top-most icon (the blue box) in the Launcher.

    1.  __Run the application__: just press the green play button.

    2.  __Debug the application__: just press the debug button. You can also put breakpoints into Ruby code. It is a bit flaky though.

-   __SSH to Server__: To connect to the server via SSH, open the terminal and type:

        jim

    This will also open a tunnel for connecting to the PgSQL database on the production server.

-   __Database__: To connect to the database (either locally or on the production server), you can use the `PgAdminIII` application (the elephant icon just underneath the `NetBeans` icon). __Important__: If you want access to the production DB, you have to connect to the production server via SSH first.

-   __Deployment__: Go to the `sources` directory, and run the following:

    1.  __Deploy locally__:

            cap localdev deploy

    2.  __Deploy to staging__ (at `dev.trainerjim.com`):

            cap staging deploy

    3.  __Deploy to dev__ (at `trainerjim.banda.si`):

            cap dev deploy

    4.  __Deploy to production__ (at `dev.trainerjim.com`):

            cap production deploy

## TODO: Mobile applications...

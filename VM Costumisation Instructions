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

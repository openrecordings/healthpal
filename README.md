# HealthPAL

## Installation
Docker is the only prerequisite

1. Clone the repo. The Git history is polluted with media files, so it's 396MB for now.

    ```
    git clone https://github.com/willhaslett/orals.git
    cd orals
    ```
1. Acquire the app's decryption key and place it in the config folder.

    ```
    echo the-key-hash > config/master.key

1. Run the installation script
1. Coffee
1. If all goes well, this will be the final output of the installation process:

    ```
    App is up and available at 127.0.0.1:3000
    Tailing Puma logs. Ctrl-C is safe

    => Booting Puma
    => Rails 6.0.0.rc1 application starting in development
    => Run `rails server --help` for more startup options
    Puma starting in single mode...
    * Version 4.3.3 (ruby 2.6.3-p62), codename: Mysterious Traveller
    * Min threads: 5, max threads: 5
    * Environment: development
    * Listening on tcp://0.0.0.0:3000
    Use Ctrl-C to stop
    ```

    If the script errors out, contact Will.

    The shell that you used for installation is now tailing the logs for the Puma webserver that is running the application locally. You can use `CTRL-C` and keep using the shell, or you can leave that shell alone so that you can see the server output after each request.

1. Create the database. After a minute or so, the asynchronous job container will start complaining because
    it can't find the appliciation's database. The server will start throwing errors like this:
    ```
    ActiveRecord::NoDatabaseError: FATAL:  database "orals_dev" does not exist
    ```
    To create the database, open a shell inside the application's container, create the database, then exit
    the container shell.
    ```
    ./docker/shell
    bundle exec rake db:reset
    exit
    ```

1. Navigate to 127.0.0.1:3000 in your browser. After a short delay, the login screen will appear.
A general purpose admin account for the application is created during installation. Log in with the
credentials below. **Never put sensitive data such as Protected Health Information in this application on
your local laptop.** The credentials for the auto-created account are:
    ```
    dev.user@example.com
    not-secure
    ```

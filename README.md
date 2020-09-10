# HealthPAL

This repository contains the source code for the HealthPAL appliction. HealthPAL is a responsive, Dockerized Ruby on Rails application that supports the creation and use of audio/video recordings made during provider/patient encounters.
It is designed to support patients in managing their own health by surfacing important discussion points that occur during clinical encounters, providing trustworthy links to information about important topics discussed during a visit,
and providing patients with the ability to share access to their visit recordings with a trusted caregiver.

## Installation
Docker is the only prerequisite

1. Clone the repo

    ```
    git clone https://github.com/willhaslett/orals.git
    cd orals
    ```
1. Acquire the app's decryption key and place it in the config folder.

    ```
    echo [the-key] > config/master.key
    ```

1. Run the development reset script to create the needed Docker images and run the containers
    ```
    ./dev-reset
    ```

1. Coffee

1. When the installation is complete, the last lines of output from the process should be:

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

    The shell that you used for installation is now tailing the logs for the Puma webserver
    that is running the application locally. You can use `CTRL-C` and keep using the shell,
    or you can leave that shell alone so that you can see the server output after each request.

1. Create the database by opening a shell inside the application's Docker container.
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

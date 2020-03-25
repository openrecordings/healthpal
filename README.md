# HealthPAL

## Installation
Docker is the only prerequisite

1. Clone the repo. The Git history is polluted with media files, so it's 396MB for now.

    ```
    git clone https://github.com/willhaslett/orals.git
    cd orals
    ```
2. Acquire the app's decryption key and place it in the config folder.

    ```
    echo the-key-hash > config/master.key

3. Run the installation script
4. Coffee
5. If all goes well, this will be the final output of the installation process:

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
6. Navigate to 127.0.0.1:3000 in your browser and after a short delay the login screen will appear. A general purpose admin account for the app is
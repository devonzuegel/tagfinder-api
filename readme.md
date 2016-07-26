# Tagfinder API

## Setting up a new Ubuntu server

1. TODO: add initial setup steps form Will.

1. Install `chruby` to install `ruby 2.3.0`. You can find more information about installing `rvm` on Ubuntu [here](http://ryanbigg.com/2014/10/ubuntu-ruby-ruby-install-chruby-and-you/).

    ```shell
    $ sudo apt-get install build-essential
    $ wget -O ruby-install-0.6.0.tar.gz \
      https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
    $ tar -xzvf ruby-install-0.6.0.tar.gz
    $ cd ruby-install-0.6.0/
    $ sudo make install
    
    # If this command succeeds with the following output,  you've successfully 
    # installed ruby-install.
    $ ruby-install -V 
        ruby-install: 0.6.0
    
    # This will take a few minutes.
    $ ruby-install --latest ruby 2.3.0
    
    $ wget -O chruby-0.3.9.tar.gz \
       https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
    $ tar -xzvf chruby-0.3.9.tar.gz
    $ cd chruby-0.3.9/
    $ sudo make install

    # Add these lines to your shell's config file to load chruby automatically.
    $ cat >> ~/.$(basename $SHELL)rc << EOF
      source /usr/local/share/chruby/chruby.sh
      source /usr/local/share/chruby/auto.sh
      EOF
    $ exec $SHELL # Reload the shell

    # If this command succeeds with the following output,  you've successfully 
    # installed chruby.
    $ chruby
        ruby-2.3.0
    
    # Make `ruby 2.3.0` the default ruby for our system.
    $ echo 'ruby-2.3.0' > ~/.ruby-version

    # If this command succeeds with the following output, you're done!.
    $ ruby -v
        ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-linux]
    ```

1. Clone this repository onto your server.

    ```shell
    $ ssh -i "privatekey.pem" ubuntu@ec2-id.aws-region.compute.amazonaws.com
    $ git clone https://github.com/devonzuegel/tagfinder-api.git
    ```

1. Install bundler on your server.

    ```shell
    $ sudo apt-get install bundler
    ```

1. Run bundler.

    ```shell
    $ bundle install
    ```

    If this fails when building nokogiri with an error that "zlib is missing; necessary for building libxml2", install zlib1g-dev and the re-run bundler:

    ```
    $ sudo apt-get install zlib1g-dev
    $ bundle
    ```

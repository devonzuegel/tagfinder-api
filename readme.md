# Tagfinder API

### Setting up a new Ubuntu server

1. `ssh` into the server you want to set up.

    ```
    $ ssh -i "privatekey.pem" ubuntu@ec2-id.aws-region.compute.amazonaws.com
    ```

1. Install `ruby 2.3.0`. 

    ```
    $ rvm install ruby-2.3.0
    ```

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

1. Clone this repository and navigate to it.

    ```shell
    $ git clone https://github.com/devonzuegel/tagfinder-api.git
    $ cd tagfinder-api
    ```

1. Install bundler on your server.

    ```shell
    $ gem install bundler
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

1. Add `.env`. (Note that this file should be within the `tagfinder-api` directory.)
    
    ```shell
    $ cat >> .env << EOF
      AWS_BUCKET_REGION=us-west-2
      AWS_ACCESS_KEY_ID=YOUR-AWS-ACCESS-KEY
      AWS_SECRET_ACCESS_KEY=YOUR-AWS-ACCESS-KEY
      AWS_S3_BUCKET=YOUR-S3-BUCKET
      TAGFINDER_KEY=YOUR-TAGFINDER-KEY
      EOF
    ```


### Build tagfinder from source

These commands work under Ubuntu 15.10. We encountered errors when running the same commands under Ubuntu 14.

1. Update `apt-get`:

    ```
    sudo apt-get update
    ```

1. Install `git`:

    ```
    sudo apt-get install git-all
    ```

    Note: At least on my local machine, it takes a while to install `git`, and I got an error, but `git` ended up seeming to work correctly.  However, `apt-get` then kept giving error messages about `runit` and `git-daemon-run`.  I found a Q&A on how to fix the problem [here](http://askubuntu.com/questions/631615/problems-with-git-all-and-15-04). 

    Based on that Q&A, I run these commands after running `sudo apt-get install git-all`, which seem to get rid of the error messages:

    ```
    sudo apt-get remove runit
    sudo apt-get remove git-daemon-run
    sudo apt-get autoremove
    ```

1. Install `llvm` (not sure if installing `llvm` is strictly necessary, but it seems like a good idea):

    ```
    sudo apt-get install llvm
    ```

1. Install `build-essential` tools (not sure if installing `build-essential` is strictly necessary, but it seems like a good idea; actually, seems to already be installed on my laptop, but running the command again doesn't hurt):

    ```
    sudo apt-get install build-essential
    ```

1. Install `clang` (currently this is equivalent to `sudo apt-get install clang-3.6`):

    ```
    sudo apt-get install clang
    ```

1. Install Boost C++ libraries:

    ```
    sudo apt-get install libboost-all-dev
    ```

1. Install `lldb`:

    ```
    sudo apt-get install lldb
    ```

1. Install C++ libraries and ABIs:

    ```
    sudo apt-get install libc++-dev libc++abi-dev
    ```

1. After installing all of the required packages, checkout the latest version of tagfinder using HTTPS:

    `git checkout https://webyrd@bitbucket.org/webyrd/tagfinder.git`

    `cd` to the top-level tagfinder directory, then build the tagfinder executable and make sure it runs:

    `make squeaky; make example`



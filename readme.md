# Tagfinder API

### Setting up a new Ubuntu server

1. Launch an EC2 instance of type `ubuntu/images/hvm/ubuntu-wily-15.10-amd64-server-20160715`. (Search `ami-92e21cf3` in the Community AMIs tab.)

1. `ssh` into the server you want to set up.

    ```shell
    chmod 400 yourprivatekey.pem
    ssh -i "yourprivatekey.pem" ubuntu@ec2-id.aws-region.compute.amazonaws.com
    ```

1. Download and run the `build-tagfinder.sh`, `install-rbenv.sh`, and `setup-server.sh` scripts from this repository into your new ec2 instance.

    ```shell
    wget https://raw.githubusercontent.com/devonzuegel/tagfinder-api/master/build-tagfinder.sh
    sh build-tagfinder.sh
    ```

    > NOTE: You will input your Bitbucket password midway through the `build-tagfinder` script.

    ```shell
    wget https://raw.githubusercontent.com/devonzuegel/tagfinder-api/master/install-rbenv.sh
    sh install-rbenv.sh
    ```

    ```shell
    wget https://raw.githubusercontent.com/devonzuegel/tagfinder-api/master/setup-server.sh
    sh setup-server.sh
    ```

1. Create a file named `.env` inside of `tagfinder-api/` (created by `setup-server.sh`) with the following contents:

    ```yaml
    AWS_BUCKET_REGION=us-west-2
    AWS_ACCESS_KEY_ID=YOUR-AWS-ACCESS-KEY-GOES-HERE
    AWS_SECRET_ACCESS_KEY=YOUR-AWS-SECRET-ACCESS-KEY-GOES-HERE
    AWS_S3_BUCKET=YOUR-S3-BUCKET-NAME-GOES-HERE

    SINATRA_ENV=production

    TAGFINDER_KEY=YOUR-SELF-DEFINED-API-KEY-GOES-HERE
    ```

1. Open port 80 on your EC2 instance. (More information at [stackoverflow.com/questions/5004159/opening-port-80-ec2-amazon-web-services](http://stackoverflow.com/questions/5004159/opening-port-80-ec2-amazon-web-services))


### Miscellaneous

- If you receive the error "Errno::EACCES - Permission denied - bin/tagfinder", run `$ chmod u+x bin/tagfinder` to update permissions on the executable.
- To start the server:

    ```shell
    screen # Create a new screen session so it remains running after you close your terminal.
    cd tagfinder-api 
    thin start
    ```

- To reattach to the screen sesion after you have closed your terminal:

    ```shell 
    screen -r # Reattach to the running screen session
    ```
# Tagfinder API

### Setting up a new Ubuntu server

0. Launch an EC2 instance of type `ubuntu/images/hvm/ubuntu-wily-15.10-amd64-server-20160715`. (Search "ami-92e21cf3" in the Community AMIs tab.)

1. `ssh` into the server you want to set up.

    ```
    $ ssh -i "privatekey.pem" ubuntu@ec2-id.aws-region.compute.amazonaws.com
    ```

2. Download and run the `setup-server.sh` script from this repository into your new ec2 instance.

```shell
sh setup-server.sh
```

3. Create a file named `.env` inside of `tagfinder-api/` (created by `setup-server.sh`) with the following contents:

```yaml
AWS_BUCKET_REGION=us-west-2
AWS_ACCESS_KEY_ID=YOUR-AWS-ACCESS-KEY-GOES-HERE
AWS_SECRET_ACCESS_KEY=YOUR-AWS-SECRET-ACCESS-KEY-GOES-HERE
AWS_S3_BUCKET=YOUR-S3-BUCKET-NAME-GOES-HERE

SINATRA_ENV=production

TAGFINDER_KEY=YOUR-SELF-DEFINED-API-KEY-GOES-HERE
```
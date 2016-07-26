## Setting up a new server instance

1. Clone this repository onto your server.

```
$ ssh -i "privatekey.pem" ubuntu@ec2-id.aws-region.compute.amazonaws.com
$ git clone https://github.com/devonzuegel/tagfinder-api.git
```

2. Install bundler on your server.

```
$ sudo apt-get install bundler
```
<!-- 
If you receive a warning that "the running version of Bundler is older than the version that created the lockfile", then install the bundler through ruby gems:

```
$ sudo gem install bundler
``` -->

3. Run bundler.

```
$ bundle
```

If this fails when building nokogiri with an error that "zlib is missing; necessary for building libxml2", install zlib1g-dev and the re-run bundler:

```
$ sudo apt-get install zlib1g-dev
$ bundle
```

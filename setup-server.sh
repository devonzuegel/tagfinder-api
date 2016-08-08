echo 'Beginning set up of tagfinder-api'
echo '-------------------------------------'

### Install necessary libraries ###

echo '>> Installing libraries...'
sudo apt-get -y update
sudo apt-get -y install git-all
sudo apt-get -y remove runit
sudo apt-get -y remove git-daemon-run
sudo apt-get -y autoremove
sudo apt-get -y install llvm
sudo apt-get -y install build-essential
sudo apt-get -y install clang
sudo apt-get -y install libboost-all-dev
sudo apt-get -y install lldb
sudo apt-get -y install libc++-dev libc++abi-dev

### Build tagfinder from source ###

echo '>> Building tagfinder from source...'
git clone https://DevonMarisa@bitbucket.org/webyrd/tagfinder.git
make squeaky; make example

### Install ruby ###

sudo apt-get update
sudo apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

echo '>> Installing rbenv...'
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo '>> Installing ruby 2.3.0...'
rbenv install 2.3.0
rbenv global 2.3.0
ruby -v

### Redirect requests to port 80 to port 8000 ###

echo '>> Redirecting requests to port 80 to port 8000...'
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8000

### Clone server repository

echo '>> Cloning tagfinder-api...'
git clone https://github.com/devonzuegel/tagfinder-api.git

echo '>> Moving tagfinder executable built from source into tagfinder-api server repository...'
yes | mv tagfinder/ms2_filter/tagfinder tagfinder-api/bin/tagfinder

echo '>> Bundling tagfinder-api dependencies...'
cd tagfinder-api
gem install bundler
bundle install

echo '>> Creating tmp directories...'
mkdir tmp
mkdir tmp/data
mkdir tmp/params

echo '>> Updating bin/tagfinder permissions...'
chmod u+x bin/tagfinder

echo '-------------------------------------'
echo '>> You have successfully downloaded the tagfinder-api server code.'
echo '>> Now, open port 80 on your EC2 instance:'
echo '>>   stackoverflow.com/questions/5004159/opening-port-80-ec2-amazon-web-services'
echo '>> Then, run the following command in a "screen" session to start the server:'
echo '>>    $ ruby run.rb'


# # \curl -sSL https://get.rvm.io | bash -s stable --ruby
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# \curl -sSL https://get.rvm.io | bash -s stable --ruby
# source /home/ubuntu/.rvm/scripts/rvm
# sudo apt-get ruby
# ruby -v
#   ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-linux]
# sudo gem install bundler
# sudo bundle install
### Install ruby ###

sudo apt-get update
sudo apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

echo -e "\n>> Installing rbenv..."
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc

git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> $HOME/.bashrc
. ~/.bashrc

echo -e "\n>> Installing ruby 2.3.0..."
rbenv install 2.3.0
rbenv global 2.3.0
ruby -v

echo -e "\n>> Redirecting requests to port 80 to port 8000..."
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8000

echo -e "\n>> Cloning tagfinder-api..."
git clone https://github.com/devonzuegel/tagfinder-api.git

echo -e "\n>> Moving tagfinder executable built from source into tagfinder-api server repository..."
yes | mv tagfinder/ms2_filter/tagfinder tagfinder-api/bin/tagfinder

echo -e "\n>> Bundling tagfinder-api dependencies..."
cd tagfinder-api
gem install bundler
bundle install

echo -e "\n>> Creating tmp directories..."
mkdir tmp
mkdir tmp/data
mkdir tmp/params

echo -e "\n>> Updating bin/tagfinder permissions..."
chmod u+x bin/tagfinder

echo '-------------------------------------'
echo '>> You have successfully downloaded the tagfinder-api server code.'
echo '>> Now, open port 80 on your EC2 instance:'
echo '>>   stackoverflow.com/questions/5004159/opening-port-80-ec2-amazon-web-services'
echo '>> Then, run the following command in a "screen" session to start the server:'
echo '>>    $ ruby run.rb'
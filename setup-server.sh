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
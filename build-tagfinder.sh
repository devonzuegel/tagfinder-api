### Install necessary libraries ###

echo ''
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

echo ''
echo '>> Building tagfinder from source...'
git clone https://DevonMarisa@bitbucket.org/webyrd/tagfinder.git
cd tagfinder
make squeaky
make
cd ..

echo '>> Done building tagfinder!'
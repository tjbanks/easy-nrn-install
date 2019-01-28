#Modified version from Ben Latimer (https://github.com/latimerb/GeneralTutorials/blob/master/nest-install.sh)
if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        exit 0
else
        echo "Installing Nest into $1/nest"
fi


#cmd line arg $1
mkdir $1/nest
cd $1/nest

wget https://github.com/nest/nest-simulator/archive/v2.16.0.tar.gz
mv v2.16.0.tar.gz nest-simulator-2.16.0.tar.gz
tar -xzvf nest-simulator-2.16.0.tar.gz
mkdir nest-simulator-2.16.0-build
cd nest-simulator-2.16.0-build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$1/nest/nest-simulator-2.16.0-build $1/nest/nest-simulator-2.16.0
make
make install

# Very important! This sets the pythonpath variable
source nest-simulator-2.16.0-build/bin/nest_vars.sh

echo "$1/nest/source nest-simulator-2.16.0-build/bin/nest_vars.sh" >> $HOME/.bashrc

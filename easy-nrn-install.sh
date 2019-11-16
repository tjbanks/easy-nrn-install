#Tyler Banks
#Grab MPI Neuron and IV, install
#Instructions from https://www.neuron.yale.edu/neuron/download/getstd
#http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1-installguide.pdf
#https://www.neuron.yale.edu/phpBB/viewtopic.php?t=3062

if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        exit 0
else
        echo "Installing Neuron into $1/nrn"
fi


#cmd line arg $1
touch $1/nrnenv
mkdir $1/nrn
echo "export NRN_INSTALL_DIR=$1/nrn" >> $1/nrnenv
echo 'export NRN_DIR=$NRN_INSTALL_DIR/neuron_install' >> $1/nrnenv
source $1/nrnenv

mkdir $NRN_DIR
cd $NRN_DIR
wget https://neuron.yale.edu/ftp/neuron/versions/v7.7/nrn-7.7.tar.gz
wget https://neuron.yale.edu/ftp/neuron/versions/v7.7/iv-19.tar.gz
tar xzf iv-19.tar.gz
tar xzf nrn-7.7.tar.gz
rm iv-19.tar.gz
rm nrn-7.7.tar.gz
# renaming the new directories iv and nrn makes life simpler later on
mv iv-19 iv
mv nrn-7.7 nrn

#Install IV

cd iv
./configure --prefix=`pwd`
make
make install

#Install neuron

cd ..
cd nrn
./configure --prefix=`pwd` --with-iv=$NRN_DIR/iv --with-nrnpython=`which python`
make
make install

cd $NRN_DIR/nrn/src/nrnpython/
python setup.py install

#Make it easy to use

echo 'export PATH="$MPI_DIR/install/bin:$PATH"' >> $1/nrnenv
echo 'export IV=$NRN_DIR/iv' >> $1/nrnenv
echo 'export N=$NRN_DIR/nrn' >> $1/nrnenv
echo 'export CPU=x86_64' >> $1/nrnenv
echo 'export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"' >> $1/nrnenv

source $1/nrnenv
echo "source $1/nrnenv" >> $HOME/.bashrc

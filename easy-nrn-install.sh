#Grab MPI Neuron and IV, install
#Instructions from https://www.neuron.yale.edu/neuron/download/getstd
#http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1-installguide.pdf
#https://www.neuron.yale.edu/phpBB/viewtopic.php?t=3062

cd $HOME
touch nrnenv

echo 'export INSTALL_DIR=$HOME' >> nrnenv
echo 'export MPI_DIR=$INSTALL_DIR/mpi_install' >> nrnenv
echo 'export NRN_DIR=$INSTALL_DIR/neuron_install' >> nrnenv
source nrnenv

mkdir $MPI_DIR
cd $MPI_DIR
mkdir install
wget http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz
tar -xvf ./mpich-3.2.1.tar.gz
cd mpich-3.2.1/
./configure --prefix=$MPI_DIR/install '--enable-shared' --disable-fortran '--disable-f77' '--disable-fc'
make
make install
export PATH="$MPI_DIR/install/bin:$PATH"

mkdir $NRN_DIR
cd $NRN_DIR
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/nrn-7.5.tar.gz
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/iv-19.tar.gz
tar xzf iv-19.tar.gz
tar xzf nrn-7.5.tar.gz
# renaming the new directories iv and nrn makes life simpler later on
mv iv-19 iv
mv nrn-7.5 nrn

#Install IV

cd iv
./configure --prefix=`pwd`
make
make install

#Install neuron

cd ..
cd nrn
./configure --prefix=`pwd` --with-iv=$NRN_DIR/iv --with-nrnpython --with-paranrn
make
make install

#Make it easy to use
cd $HOME
echo 'source $HOME/nrnenv' >> $HOME/.bashrc

echo 'export PATH="$MPI_DIR/install/bin:$PATH"' >> nrnenv
echo 'export IV=$NRN_DIR/iv' >> nrnenv
echo 'export N=$NRN_DIR/nrn' >> nrnenv
echo 'export CPU=x86_64' >> nrnenv
echo 'export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"' >> nrnenv
source nrnenv

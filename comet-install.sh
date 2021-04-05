# These commands should be run line by line in the terminal. Not sure what will happen if run as a script.

module load gnu
module load openmpi_ib
module load python

wget https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh
sh Anaconda3-5.1.0-Linux-x86_64.sh

# At this point you will need to exit out of the terminal and log back in.

module load gnu
module load openmpi_ib

# Installing Neuron 7.7 newer versions have problems 
wget https://neuron.yale.edu/ftp/neuron/versions/v7.7/nrn-7.7.tar.gz
tar xzf nrn-7.7.tar.gz
mv nrn-7.7 nrn
cd nrn
autoreconf --force --install
./configure --prefix=`pwd` --without-x --with-paranrn --with-nrnpython=python --disable-rx3d  
make -j install
cd ..

# install bmtk
# using to be git clone https://github.com/AllenInstitute/bmtk.git
git clone https://github.com/aaberbach/bmtk.git
cd bmtk
python setup.py install -user
cd ..

# install mpi4py
wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.2.tar.gz

tar -zxf mpi4py-3.0.2.tar.gz
cd mpi4py-3.0.2

python setup.py build

python setup.py install -user
cd ..

# These commands should be run line by line in the terminal. Not sure what will happen if run as a script.

module load gnu
module load openmpi_ib
module load python

wget https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh
sh Anaconda3-5.1.0-Linux-x86_64.sh

# At this point you will need to exit out of the terminal and log back in.

module load gnu
module load openmpi_ib

mkdir neuron
cd neuron
git clone http://github.com/neuronsimulator/nrn
cd nrn
sh build.sh
./configure --prefix=`pwd` --without-x --with-paranrn --with-nrnpython=python --disable-rx3d  
make -j install

# Put these lines in your ~/.bashrc file
export PYTHONPATH=$HOME/neuron/nrn/lib/python:$PYTHONPATH
export PATH=$HOME/neuron/nrn/x86_64/bin:$PATH

# install bmtk
git clone https://github.com/AllenInstitute/bmtk.git
cd bmtk
python setup.py install

# install mpi4py
wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.2.tar.gz

tar -zxf mpi4py-3.0.2.tar.gz
cd mpi4py-3.0.2

python setup.py build

python setup.py install

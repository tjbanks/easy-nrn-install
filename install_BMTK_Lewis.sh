#!/bin/bash

# Adapted from Songjie Wang's script located here: https://github.com/wangso/BMTK_Lewis/blob/master/Lewis_setup.sh

if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        echo "Usage: install_BMTK_Lewis.sh [install directory]"
        echo "Ex: install_BMTK_Lewis.sh ."
        exit 0
else
        echo "Installing into `realpath $1`"
fi


installdir=`realpath $1`

echo "loading Lewis system libraries (ignore some of the error messages)"
module load automake/automake-1.16.1-gcc-4.9.2
module load autoconf/autoconf-2.69-gcc-4.9.2
export OMPI_MCA_btl_openib_if_include='mlx5_3:1'
module load libtool/libtool-2.4.6-gcc-4.9.2
module load gcc/gcc-5.4.0
module load bison/bison-3.0.4
module load flex/flex-2.6.4
module load python/python-3.6.5

cd $installdir
echo "Installing openmpi-4.0.1" #(I had to install this myself as the Lewis library won't work, at least for me)
echo "Downloading..."
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz
mkdir openmpi-4.0.1
mkdir openmpi-4.0.1-install
mv openmpi-4.0.1.tar.gz openmpi-4.0.1/
cd openmpi-4.0.1
tar -xzvf openmpi-4.0.1.tar.gz openmpi-4.0.1/
./configure --prefix=$installdir/openmpi-4.0.1-install 
make -j install

echo "Adding openmpi to .bashrc"
export PATH=$installdir/openmpi-4.0.1-install:$PATH

cd $installdir
echo "Installing mpi4py"
echo "Downloading..."
wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.2.tar.gz
tar -zxf mpi4py-3.0.2.tar.gz
cd mpi4py-3.0.2
#nano mpi.cfg
#	under [openmpi]
#	change  mpi_dir=$installdir/opoenmpi-4.0.1-install 
sed -i 's/mpi_dir.*/mpi_dir=$installdir\/opoenmpi-4.0.1-install/' $installdir/mpi4py-3.0.2/mpi.cfg
python setup.py build --mpi=openmpi
python setup.py install --user

cd $installdir
echo "installing neuron with openmpi"
mkdir neuron
cd neuron
git clone http://github.com/neuronsimulator/nrn
cd nrn
sh build.sh
./configure --prefix=`pwd` --without-x --with-paranrn=$installdir/opoenmpi-4.0.1-install/lib/openmpi --with-nrnpython=python --disable-rx3d
make -j install

# Put these lines in your ~/.bashrc file
export PYTHONPATH=$installdir/neuron/nrn/lib/python:$PYTHONPATH
export PATH=#installdir/neuron/nrn/x86_64/bin:$PATH

cd $installdir
echo "Installing bmtk"
git clone https://github.com/AllenInstitute/bmtk.git
cd bmtk
python setup.py install --user

# in Lewis sbatch files, remove "source activate bmtk_env" and "source deactivate" 
# in Lewis sbatch files,  remove "module load openmpi/openmpi-2.0.0" and "module unload openmpi/openmpi-2.0.0"

# for batch_lewis_run.sh to run correctly, run the following 
#cd  SPWR_BMTK/biophys_components/mechanisms/
#rm -rf x86_64/
#nrnivmodl modfiles

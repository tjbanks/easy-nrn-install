#!/bin/bash
#Uncomment the following two lines to debug script line by line
#set -x
#trap read debug

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
#module load gcc/gcc-5.4.0
module load gcc/gcc-4.9.4
module load bison/bison-3.0.4
module load flex/flex-2.6.4
module load python/python-3.6.5

cd $installdir
echo "Installing pip"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user

cd $installdir
echo "Installing openmpi" #(I had to install this myself as the Lewis library won't work, at least for me)
echo "Downloading..."
mkdir openmpi-install
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz
tar -xzvf openmpi-4.0.1.tar.gz
cd openmpi-4.0.1
#wget http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz
#tar -xf ./mpich-3.2.1.tar.gz
#cd mpich-3.2.1
./configure --prefix=$installdir/openmpi-install #--enable-shared --disable-fortran --disable-f77 --disable-fc 
make -j install

echo "Adding openmpi to .bashrc"
export PATH=$installdir/openmpi-install:$PATH

echo "export PATH=$installdir/openmpi-install:\$PATH" >> ~/.bashrc

cd $installdir
echo "Installing mpi4py"
echo "Downloading..."
wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.2.tar.gz
tar -zxf mpi4py-3.0.2.tar.gz
cd mpi4py-3.0.2
#nano mpi.cfg
#	under [openmpi]
#	change  mpi_dir=$installdir/opoenmpi-4.0.1-install 
sed -i "s/mpi_dir.*=.*/mpi_dir=$installdir/openmpi-install/" $installdir/mpi4py-3.0.2/mpi.cfg
python3 setup.py build --mpi=openmpi
python3 setup.py install --user

cd $installdir
echo "installing neuron with openmpi"
mkdir neuron
cd neuron
git clone http://github.com/neuronsimulator/nrn
cd nrn
sh build.sh
./configure --prefix=`pwd` --without-x --with-paranrn=$installdir/openmpi-install/lib/openmpi --with-nrnpython=python --disable-rx3d
make -j install

# Put these lines in your ~/.bashrc file
export PYTHONPATH=$installdir/neuron/nrn/lib/python:$PYTHONPATH
export PATH=$installdir/neuron/nrn/x86_64/bin:$PATH

echo "export PYTHONPATH=$installdir/neuron/nrn/lib/python:\$PYTHONPATH" >> ~/.bashrc
echo "export PATH=$installdir/neuron/nrn/x86_64/bin:\$PATH" >> ~/.bashrc

cd $installdir
echo "Installing bmtk"
git clone https://github.com/AllenInstitute/bmtk.git
cd bmtk
python3 setup.py install --user

echo "Adding load module python3 to .bashrc, type python3 to use python"
echo "module load python/python-3.6.5" >> ~/.bashrc
echo ""
echo "DONE."
echo "Log out then log back in for a working installation, or type:"
echo "source ~/.bashrc"


# in Lewis sbatch files, remove "source activate bmtk_env" and "source deactivate" 
# in Lewis sbatch files,  remove "module load openmpi/openmpi-2.0.0" and "module unload openmpi/openmpi-2.0.0"

# for batch_lewis_run.sh to run correctly, run the following 
#cd  SPWR_BMTK/biophys_components/mechanisms/
#rm -rf x86_64/
#nrnivmodl modfiles

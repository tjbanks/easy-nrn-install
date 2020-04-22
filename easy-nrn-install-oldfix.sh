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
source $1/nrnenv

cd $1
cd nrn/neuron_install/nrn/src/nrnpython/
python setup.py install

#Make it easy to use

echo 'export PATH="$MPI_DIR/install/bin:$PATH"' >> $1/nrnenv
echo 'export IV=$NRN_DIR/iv' >> $1/nrnenv
echo 'export N=$NRN_DIR/nrn' >> $1/nrnenv
echo 'export CPU=x86_64' >> $1/nrnenv
echo 'export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"' >> $1/nrnenv

source $1/nrnenv
echo "source $1/nrnenv" >> $HOME/.bashrc

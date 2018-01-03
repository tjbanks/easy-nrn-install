#Grab Neuron and IV, install
#Instructions from https://www.neuron.yale.edu/neuron/download/getstd

cd $HOME
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/nrn-7.5.tar.gz
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/iv-19.tar.gz

mkdir neuron-install
mv iv-19.tar.gz neuron
mv nrn-7.5.tar.gz neuron
cd neuron-install
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
./configure --prefix=`pwd` --with-iv=$HOME/neuron-install/iv --with-nrnpython
make
make install


#Make it easy to use

echo 'source $HOME/neuron-install/nrnenv' >> $HOME/.bashrc

touch $HOME/neuron-install/nrnenv
echo 'export IV=$HOME/neuron-install/iv' >> $HOME/neuron-install/nrnenv
echo 'export N=$HOME/neuron-install/nrn' >> $HOME/neuron-install/nrnenv
echo 'export CPU=x86_64' >> $HOME/neuron-install/nrnenv
echo 'export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"' >> $HOME/neuron-install/nrnenv

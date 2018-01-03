#Grab Neuron and IV, install
#Instructions from https://www.neuron.yale.edu/neuron/download/getstd

cd $HOME
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/nrn-7.5.tar.gz
wget https://neuron.yale.edu/ftp/neuron/versions/v7.5/iv-19.tar.gz

mkdir neuron
mv iv-19.tar.gz neuron
mv nrn-7.5.tar.gz neuron
cd neuron
tar xzf iv-mm.tar.gz
tar xzf nrn-nn.tar.gz
# renaming the new directories iv and nrn makes life simpler later on
mv iv-mm iv
mv nrn-nn nrn

#Install IV

cd iv
./configure --prefix=`pwd`
make
make install

#Install neuron

cd ..
cd nrn
./configure --prefix=`pwd` --with-iv=$HOME/neuron/iv --with-nrnpython
make
make install


#Make it easy to use

echo 'source $HOME/neuron/nrnenv' >> $HOME/.bashrc

touch $HOME/neuron/nrnenv
echo 'export IV=$HOME/neuron/iv' >> $HOME/neuron/nrnenv
echo 'export N=$HOME/neuron/nrn' >> $HOME/neuron/nrnenv
echo 'export CPU=x86_64' >> $HOME/neuron/nrnenv
echo 'export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"' >> $HOME/neuron/nrnenv

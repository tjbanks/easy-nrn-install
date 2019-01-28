#Ensure the latest version from here: https://www.anaconda.com/download/
#Download Anaconda3

if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        exit 0
else
        echo "Installing Anaconda into $1/conda"
fi


mkdir $1/conda_temp
cd $1/conda_temp
wget https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh
chmod +x Anaconda3-2018.12-Linux-x86_64.sh
./Anaconda3-2018.12-Linux-x86_64.sh -b -p $1/conda
cd $1
rm -rf $1/conda_temp

export PATH="$1/conda/bin:$PATH"
conda create -y -n py36 python=3.6 anaconda
conda activate py36

touch $1/activate_conda.sh
chmod +x $1/activate_conda.sh
echo "export PATH=\"$1/conda/bin:$PATH\"" >> $1/activate_conda.sh
echo "source activate py36" >> $1/activate_conda.sh

source $1/activate_conda.sh
echo "source $1/activate_conda.sh" >> $HOME/.bashrc

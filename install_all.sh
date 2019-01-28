#Use by running install_all.sh $HOME to install in your home directory
if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        exit 0
else
        echo "Installing into $1"
fi

mkdir $1/utils
./easy-conda-install.sh $1/utils
./easy-nrn-install.sh $1/utils
./easy-bmtk-install.sh $1/utils
./easy-nest-install.sh $1/utils


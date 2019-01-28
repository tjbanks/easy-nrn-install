#Simple pip install of bmtk, this can be run multiple times for updated versions

if [ -z $1 ]; then
        echo "Directory to install not specified, exiting."
        exit 0
else
        echo "Installing into $1"
fi

cd $1
mkdir bmtk-repo
cd bmtk-repo
git clone https://github.com/AllenInstitute/bmtk
cd bmtk
pip uninstall bmtk
python setup.py install

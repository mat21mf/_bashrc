sudo apt install --no-install-recommends dos2unix

cp -p -u .bashrc ~/.bashrc
cp -p -u .bash_functions ~/.bash_functions
cp -p -u .bash_aliases ~/.bash_aliases
dos2unix ~/.bashrc
dos2unix ~/.bash_functions
dos2unix ~/.bash_aliases

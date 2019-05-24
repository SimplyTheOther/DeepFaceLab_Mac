# OS X Installer - CPU variant
# install general dependencies
. osx-base-installer.sh

# install DeepFaceLab Python dependencies
python3 -m pip install -r requirements-cpu.txt

echo "Please reboot your system to let the new changes take effect."

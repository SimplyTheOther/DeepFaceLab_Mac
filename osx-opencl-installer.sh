# OS X Installer - OpenCL variant
# install general dependencies
. osx-base-installer.sh

# install DeepFaceLab Python dependencies
python3 -m pip install -r requirements-opencl.txt

echo "Please reboot your system to let the new changes take effect."

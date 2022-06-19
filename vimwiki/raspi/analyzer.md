## analyzer
#### QT
qt5-default qtbase5-private-dev qtdeclarative5-dev qtdeclarative5-private-dev qml qmlscene

qtcreator qml-module-qtquick-controls2

# rfanalyzer
git clone https://github.com/greatscottgadgets/hackrf
sudo apt install libfftw3-dev libusb-1.0-0-dev libusb-1.0-0
cd hackrf/host
cmake
make
sudo make install
git clone https://github.com/xmikos/qspectrumanalyzer
sudo apt install python3-numpy python3-pyqt5 python3-pyqtgraph python3-pyqt5.qwt python3-qtpy
sudo apt install python3-soapysdr soapysdr-tools
cd qspectrumanalyzer
pip3 install .

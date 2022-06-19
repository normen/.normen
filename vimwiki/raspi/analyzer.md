## analyzer
```bash
sudo apt install cmake
git clone https://github.com/greatscottgadgets/hackrf
sudo apt install libfftw3-dev libusb-1.0-0-dev
cd hackrf/host
cmake .
make
sudo make install
git clone https://github.com/xmikos/qspectrumanalyzer
sudo apt install python3-numpy python3-pyqt5 python3-pyqtgraph
cd qspectrumanalyzer
pip3 install .
```

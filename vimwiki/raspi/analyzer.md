## analyzer
```bash
# qspectrumanalyzer / hackrf
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

# cutiepi-shell optional
sudo mv /etc/xdg/autostart/cutiepi-shell.desktop ~/.local/share/applications/

# autorotate & start qspectrum
sudo ~/.local/bin/startup.sh
<<CONTENT
lxterminal --command="xrandr --output DSI-1 --rotate left"
qspectrumanalyzer
CONTENT

sudo vim /etc/xdg/autostart/startup-qspectrum.desktop
<<CONTENT
[Desktop Entry]
Type=Application
Name=Qspectrum-Start
Comment=Rotation+Start
Exec=/home/pi/.local/bin/startup.sh
NotShowIn=GNOME;KDE;XFCE;
CONTENT

# battery display
git clone https://github.com/cutiepi-io/cutiepi-middleware
cd cutiepi-middleware/lxpanel-battery-plugin
sudo apt install \
  build-essential autoconf automake libtool intltool \
  libglib2.0-dev libgtk2.0-dev lxpanel-dev libdbus-glib-1-dev
./autogen.sh
./configure
make
sudo make install
lxpanelctl restart
#add via right-click on panel

# autostart (not used)
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/
vim ~/.config/lxsession/LXDE-pi/autostart
```

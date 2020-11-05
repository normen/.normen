## windows
```
# Fixes
sfc /scannow

DISM.exe /Online /Cleanup-image /Restorehealth

# install node.js via installer
# build tools (admin)
npm install -g windows-build-tools
# install git, cmake via installer
# install VS Community via installer

#darknet
#vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
set VCPKG_ROOT =  install path of vcpkg
set VCPKG_DEFAULT_TRIPLET = x64-windows

git clone https://github.com/AlexeyAB/darknet

# make caps lock ctrl
# in admin powershell:
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

```

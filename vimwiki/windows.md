## windows
```
# run and close minimized shell command app
start /min "VISCA-CONTROL" node c:\Users\Normen\Code\obs-visca-control\index.js
taskkill /FI "WindowTitle eq VISCA-CONTROL"

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
# in admin powershell: (or use powerToys)
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# powerToys! Keyboard remappng for Ctrl-Ä
https://github.com/microsoft/PowerToys

# Services
Start-Service servicename
Restart-Service servicename
Stop-Service servicename

# Event Log
Get-EventLog -LogName Application -Newest 10

# OpenSSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Set-Service -Name sshd -StartupType 'Automatic'
Set-Service -Name ssh-agent -StartupType 'Automatic'
Start-Service ssh-agent
Start-Service sshd

# set linux as login shell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\WINDOWS\System32\wsl.exe" -PropertyType String -Force

# for admin accounts copy authorized_keys to:
$acl = Get-Acl C:\ProgramData\ssh\administrators_authorized_keys
$acl.SetAccessRuleProtection($true, $false)
$administratorsRule = New-Object system.security.accesscontrol.filesystemaccessrule("Administrators","FullControl","Allow")
$systemRule = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM","FullControl","Allow")
$acl.SetAccessRule($administratorsRule)
$acl.SetAccessRule($systemRule)
$acl | Set-Acl

# Alternative:
vim C:\ProgramData\ssh\sshd_config
# comment out:
# AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
# add:
PasswordAuthentication no
restart-service sshd
```

## macos
```bash
# log all
sudo log stream --style compact --predicate 'messageType == "error" || messageType == "fault"'

# get password from keychain
security find-internet-password -gs google.com -w

# log iCloud Drive activity
brctl log -wt //--wait --shorten
brctl log -wtl 6 //no debug

# soft fix icloud sync
chown -R normenhansen:staff ~/Library/Mobile\ Documents/
chmod -R 755 ~/Library/Mobile\ Documents/

# hard fix icloud sync loop
killall bird
cd ~/Library/Application\ Support
sudo rm -rf CloudDocs
sudo reboot


# brew -> see brew doc

# disk permissions
#erst im finder home resetten (Apfel-I, schloss)
#ab mojave terminal in sicherheit auf festplattenvollzugriff
diskutil resetUserPermissions / `id -u`
#chmod .ssh/id !

# quicklook from terminal
qlmanage -p FILE

# bitlbee
brew install bitlbee
bitlbee -d ~/.bitlbee -D -i 127.0.0.1
# discord for bitlbee
brew install autoconf automake
git clone https://github.com/sm00th/bitlbee-discord
cd bitlbee-discord
./autogen.sh
./configure --with-plugindir=/usr/local/lib/bitlbee --prefix=/usr/local
make
make install

# cordless discord client
brew tap Bios-Marcel/cordless
brew install cordless
#go get -u github.com/Bios-Marcel/cordless

#ttrv reddit client
pip3 install ttrv

# notmuch mail
brew install notmuch
brew install isync
vim ~/.mbsyncrc
<<CONTENT
# Based on http://www.macs.hw.ac.uk/~rs46/posts/2014-01-13-mu4e-email-client.html
IMAPAccount icloud
Host imap.mail.me.com
User normen #not XXX@me.com etc.
PassCmd "security find-internet-password -gs IMAPSERVER -w"
Port 993
SSLType IMAPS
SSLVersions TLSv1.2
AuthMechs PLAIN

IMAPStore icloud-remote
Account icloud

MaildirStore icloud-local
Path ~/.mbsync/icloud/
Inbox ~/.mbsync/icloud/inbox
Trash Trash

#
# Channels and Groups 
# (so that we can rename local directories and flatten the hierarchy)
#
#
Channel icloud-folders
Master :icloud-remote:
Slave :icloud-local:
Patterns "INBOX" "Saved" "Drafts" "Archive" "Sent*" "Trash"
Create Both
Expunge Both
SyncState *

Group icloud
Channel icloud-folders
CONTENT

mbsync -a
notmuch
/usr/local/Cellar/ruby/2.7.1_2/bin/gem install mail
cd ~/.vim/pack/default/start/
git clone https://github.com/imain/notmuch-vim

## quspectrumanalyzer
checkout git
sudo pip3 install .
```

# aerc mail
brew install go scdoc
git clone https://git.sr.ht/~sircmpwn/aerc
cd aerc
make
#OR
GOFLAGS=-tags=notmuch make
# to use all filters:
brew install jp2a imagemagick poppler catimg w3c dante
# to use sh -c "contacts '%s'|sed '/^NAME/ d'"
brew install keith/formulae/contacts-cli

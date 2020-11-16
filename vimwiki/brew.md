# brew
```bash
# install xcode tools!
xcode-select --install

# install software - no sudo!
brew install XXX
# casks
brew cask install freecad

# show info/options
brew info installname

# show top level packages
brew leaves

# fix issues
brew doctor

#update
brew update
brew upgrade

# different version
brew search node
#This might give you the follow results:
heroku/brew/heroku-node ✔
llnode
node@10
nodebrew
leafnode
node ✔
node@8
....
brew install node@8

brew unlink node

brew link node@8

#For some older node versions (which are keg-only), it might be required to link them with the --force and --overwrite options:
brew link --force --overwrite node@8

# create go package
brew create --go https://github.com/normen/whatscli/archive/v0.4.2.tar.gz
vim /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/whatscli.rb
<<CONTENT
  def install
    system "go", "build", *std_go_args, "-o", "whatscli"
    mkdir bin.to_s
    cp "whatscli", "#{bin}/"
  end
CONTENT
brew audit --new-formula whatscli
```

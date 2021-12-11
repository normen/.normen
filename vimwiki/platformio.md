## PlatformIO
```bash
brew install platformio

# create project
# boards: d1_mini micro
pio init --ide vim --board micro

# libs
pio lib search xxx
pio lib install xxx

# monitor
pio device monitor

# vim/coc completion
brew install ccls
# replace first line in .ccls with "clang"!
vim ~/.vim/coc-settings.json
<<CONTENT
{
  "languageserver": {
    "ccls": {
      "command": "ccls",
      "filetypes": ["c", "cpp", "objc", "objcpp"],
      "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
      "initializationOptions": {
         "cache": {
           "directory": "/tmp/ccls"
         }
       }
    }
  }
}
CONTENT

# install ccls debian
sudo apt install snapd
sudo snap install core
sudo snap install ccls --classic
```

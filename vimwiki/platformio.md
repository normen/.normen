## PlatformIO
```bash
brew install platformio

# create project
# boards: d1_mini micro
pio init --ide vim --board micro

# vim/coc completion
brew install ccls
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
```

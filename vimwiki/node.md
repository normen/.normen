## NPM
```bash
# log into account
npm login
# init project
npm init
# update version
npm version patch/minor/major
# publish
npm publish
# publish beta/next/etc
npm publish --tag next
# add owner to project
npm owner add normen
# install package and save in package.json
npm install --save mypackage
# install dev to global
sudo npm link
# install only production local
npm install --production
# install with compilation
npm install packagename --unsafe-perm
# install wihout binary links
npm install packagename --no-bin-links
```
## node
```bash
#install Node.js
#curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
#sudo apt install -y nodejs

# install using N
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
bash n lts

#up/downgrade Node.js
sudo npm cache clean -f
sudo npm install -g n
sudo n 10.15.3

#rebuild
sudo npm rebuild --unsafe-perm (in module folder)

#8.15.0 / 10.15.3
remove node: (in prefix path)
rm -rf bin/node bin/node-waf include/node lib/node lib/pkgconfig/nodejs.pc share/man/man1/node.1

#install npm if broken
curl -0 -L https://npmjs.com/install.sh | sudo sh

# create
npm init
npm install --save xxx

# update
sudo npm update -g (package)

# list outdated
npm outdated --global

# list installed
npm list --global

# install npm
sudo npm i -g npm

# install dev folder globally
npm link 

npm normal installer from web

sudo npm install -g --save-dev electron
sudo npm install -g --save-dev electron-rebuild
sudo npm install -g --save-dev electron-builder

# jQuery import:
<script src="jquery.js" onload="window.$ = window.jQuery = module.exports;"></script>

# electron-builder alle plattformen:
build -mwl

# fix native build if electron-rebuild doesn't
node-gyp rebuild --target=1.6.10 --arch=x64 --dist-url=https://atom.io/download/atom-shell

## cool packages (https://electron.atom.io/community/)
electron-settings
electron-sudo

npm install jsoneditor -> javascript json editor panels (netbeans style)

##games:
babylonjs -> 3d jME-style engine
nano-ecs -> Entity system

### (command line) executables
npm install -g pkg
pkg . #-> package native binary incl. runtime
<<CONTENT package.json
  "bin": "index.js",
  "pkg":{
    "targets": ["node10-macos-x64"]
  },
CONTENT
```

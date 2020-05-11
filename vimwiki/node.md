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
#### code snippets
```javascript
## JAVASCARIPT
# download file
var http = require('http');
var fs = require('fs');
var file = fs.createWriteStream("file.jpg");
var request = http.get("http://i3.ytimg.com/vi/J---aiyznGQ/mqdefault.jpg", function(response) {
  response.pipe(file);
});

# object to array
var data = object;
var array = $.map(data, function(value, index){return [value]});

# full HTTP file server
const http = require('http');
const url = require('url');
const fs = require('fs');
const path = require('path');
const port = process.argv[2] || 9000;
http.createServer(function (req, res) {
  console.log(`${req.method} ${req.url}`);
  // parse URL
  const parsedUrl = url.parse(req.url);
  // extract URL path
  let pathname = `.${parsedUrl.pathname}`;
  // based on the URL path, extract the file extention. e.g. .js, .doc, ...
  const ext = path.parse(pathname).ext;
  // maps file extention to MIME typere
  const map = {
    '.ico': 'image/x-icon',
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.json': 'application/json',
    '.css': 'text/css',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.wav': 'audio/wav',
    '.mp3': 'audio/mpeg',
    '.svg': 'image/svg+xml',
    '.pdf': 'application/pdf',
    '.doc': 'application/msword'
  };
  fs.exists(pathname, function (exist) {
    if(!exist) {
      // if the file is not found, return 404
      res.statusCode = 404;
      res.end(`File ${pathname} not found!`);
      return;
    }
    // if is a directory search for index file matching the extention
    if (fs.statSync(pathname).isDirectory()) pathname += '/index' + ext;
    // read file from file system
    fs.readFile(pathname, function(err, data){
      if(err){
        res.statusCode = 500;
        res.end(`Error getting the file: ${err}.`);
      } else {
        // if the file is found, set Content-type and send data
        res.setHeader('Content-type', map[ext] || 'text/plain' );
        res.end(data);
      }
    });
  });
}).listen(parseInt(port));
console.log(`Server listening on port ${port}`);

## random data:
    var dataPoints = [];
    for (var i = 0; i < limit; i += 1) {
      y += (Math.random() * 10 - 5);
      dataPoints.push({
        x: i - limit / 2,
        y: y
      });
    }

## debounce or throttle a function parameter
var helpers = {
  /**
   * debouncing, executes the function if there was no new event in $wait milliseconds
   * @param func
   * @param wait
   * @param scope
   * @returns {Function}
   */
  debounce: function(func, wait, scope) {
    var timeout;
    return function() {
      var context = scope || this, args = arguments;
      var later = function() {
        timeout = null;
        func.apply(context, args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  },
  
  /**
   * In case of a "storm of events", this executes once every $threshold
   * @param fn
   * @param threshold
   * @param scope
   * @returns {Function}
   */
  throttle: function(fn, threshold, scope) {
    threshold || (threshold = 250);
    var last, deferTimer;
    
    return function() {
      var context = scope || this;
      var now = +new Date, args = arguments;
      
      if (last && now < last + threshold) {
        // Hold on to it
        clearTimeout(deferTimer);
        deferTimer = setTimeout(function() {
          last = now;
          fn.apply(context, args);
        }, threshold);
      } else {
        last = now;
        fn.apply(context, args);
      }
    };
  }
}

var resizeHandler = function(){
  this.doSomeMagic();
  this.blackMagic();
}

// Debounce by waiting 0.25s (250ms) with "this" context
window.addEventListener('resize', helpers.debounce(resizeHandler, 250, this));
```

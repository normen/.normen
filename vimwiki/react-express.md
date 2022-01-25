## express + react
### Install
```bash
npx express-generator my-webapp
cd my-webapp
vim package.json # jade -> pug 2.0.4
vim app.js # jade->pug
cd views
for f in *.jade; do mv -- "$f" "${f%jade}pug";done
cd ..

npx create-react-app client
cd client
vim package.json
# "proxy": "http://localhost:3001"
# scripts/"start": "PORT=3000 react-scripts start"

```
### Libs
```bash
cd client
# chakra UI
npm install --save @chakra-ui/core
# fetch
npm install --save whatwg-fetch
```
```javascript
// using fetch API
fetch('/bookings')
.then(function(response) {
return response.json()
}).then(function(json) {

}).catch(function(ex) {

}).finally(function(){

});

```

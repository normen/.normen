## vite -> web app only
```bash
npm create vite@latest
cd project
npm install
npm run dev
```
## express + react (old)
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
npm i --save @chakra-ui/react @emotion/react @emotion/styled framer-motion
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

{variable == true ?
  <React/>
:
  <OtherReact/>
}
{appointments.map((appointment, idx) =>
  <React>{appointment}</React>
)}

```

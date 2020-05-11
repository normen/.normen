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

```

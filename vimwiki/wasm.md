## WASM
```bash
# C/C++ - emscripten
brew install emscripten
emconfigure ./configure
emmake make

# GO
GOOS=js GOARCH=wasm go build -o app.wasm
```

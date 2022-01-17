## WASM
```bash
# A-Shell wasi SDK:
git clone --recurse-submodules https://github.com/holzschu/wasi-sdk.git
cd wasi-sdk
# To compile, first edit src/llvm-project/clang/CMakeLists.txt
# and comment lines 296 to 316 (the 20 lines after set(CUDA_ARCH_FLAGS "sm_35"), then type:
vim src/llvm-project/clang/CMakeLists.txt
env PREFIX=/opt/ make

# to use the compiler:
export WASI_SDK_PATH=`pwd`/wasi-sdk-${WASI_VERSION_FULL}
CC="${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot"
$CC foo.c -o foo.wasm


# C/C++ - emscripten
brew install emscripten
emconfigure ./configure --prefix=`pwd`/build
emmake make && emmake make install

# GO
GOOS=js GOARCH=wasm go build -o app.wasm

# aShhell WASI
git clone --recurse-submodules https://github.com/holzschu/wasi-sdk.git
env PREFIX=[PATH_FOR_INSTALL]/wasi-sdk/opt/ make
CC="[WASI_SDK_PATH]/bin/clang --sysroot=[WASI_SDK_PATH]/share/wasi-sysroot"

# build ncurses
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz
wget https://raw.githubusercontent.com/jamesbiv/ncurses-emscripten/master/ncurses-6.1_emscripten.patch
tar -xzvf ncurses-6.1.tar.gz
patch -p0 < ncurses-6.1_emscripten.patch
cd ncurses-6.1
./configure --prefix=`pwd`/build
make -j4 && make install
emconfigure ./configure --prefix=`pwd`/build --enable-widec --without-manpages --without-tests
vim ./Makefile
<<CONTENT
Line 113
#cd man && ${MAKE} ${TOP_MFLAGS} $@
Line 116
#cd progs && ${MAKE} ${TOP_MFLAGS} $@
Line 120
#cd test && ${MAKE} ${TOP_MFLAGS} $@
Line 121
#cd misc && ${MAKE} ${TOP_MFLAGS} $@
Line 122
#cd c++ && ${MAKE} ${TOP_MFLAGS} $@
CONTENT
vim ./ncurses/Makefile
<<CONTENT
From line 233
#make_keys$(BUILD_EXEEXT) : \
#               $(tinfo)/make_keys.c \
#               names.c
#       $(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(tinfo)/make_keys.c $(BUILD_LDFLAGS) $(BUILD_LIBS)

#make_hash$(BUILD_EXEEXT) : \
#               $(tinfo)/make_hash.c \
#               ../include/hashsize.h
#       $(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(tinfo)/make_hash.c $(BUILD_LDFLAGS) $(BUILD_LIBS)

#report_offsets$(BUILD_EXEEXT) : \
#               $(srcdir)/report_offsets.c
#       $(BUILD_CC) -o $@ $(BUILD_CPPFLAGS) $(BUILD_CCFLAGS) $(srcdir)/report_offsets.c $(BUILD_LDFLAGS) $(BUILD_LIBS)

From line 283
#       -rm -f make_keys$(BUILD_EXEEXT)
#       -rm -f make_hash$(BUILD_EXEEXT)
#       -rm -f report_offsets$(BUILD_EXEEXT)
CONTENT
make clean
emmake make -j4 && emmake make install

# build other project:
emconfigure ./configure LDFLAGS="-L/Users/normenhansen/Dev/src/ncurses-6.1/build/lib" CFLAGS="-I/Users/normenhansen/Dev/src/ncurses-6.1/build/include" CXXFLAGS="-I/Users/normenhansen/Dev/src/ncurses-6.1/build/include" LIBS="-lncurses" --prefix=`pwd`/build
emmake make && emmake make install
# vifm
emconfigure ./configure --with-curses="/Users/normenhansen/Dev/src/ncurses-6.1/build" --prefix=`pwd`/build
emmake make -j4 && emmake make install
# copy share and src/vifm.wasm
```

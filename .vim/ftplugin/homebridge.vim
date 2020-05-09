set makeprg=homebridge\ -I\ -U\ ~/npm-code/testhomebridge/.homebridge

" (c) https://github.com/felixge/vim-nodejs-errorformat/blob/master/ftplugin/javascript.vim
" Error: bar
"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let &errorformat  = '%AError: %m' . ','
let &errorformat .= '%AEvalError: %m' . ','
let &errorformat .= '%ARangeError: %m' . ','
let &errorformat .= '%AReferenceError: %m' . ','
let &errorformat .= '%ASyntaxError: %m' . ','
let &errorformat .= '%ATypeError: %m' . ','
let &errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','
"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let &errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
"     at node.js:903:3
let &errorformat .= '%*[\ ]at\ %f:%l:%c' . ','
" /Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2
"   throw new Error('bar');
"         ^
let &errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','
" Ignore everything else
let &errorformat .= '%-G%.%#'

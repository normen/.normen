" PLUGINS
silent! call plug#begin('$NORMEN/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
" core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdcommenter'
" git
Plug 'tpope/vim-fugitive'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
" tools
Plug 'tpope/vim-dispatch'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
" tmux
if executable('tmux')
  Plug 'tpope/vim-tbone'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'roxma/vim-tmux-clipboard'
  Plug 'wellle/tmux-complete.vim'
endif
" coc
if executable('node')
  Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
endif
" maptool ft
Plug 'normen/mtgvim', { 'for': 'mtmacro' }
" openscad ft
Plug 'Lattay/vim-openscad', { 'for': 'openscad' }
" hex mode
Plug 'fidian/hexmode'
" presentation
Plug 'sotte/presenting.vim'
" ASCII drawing
Plug 'normen/DrawIt'
" Tables
Plug 'dhruvasagar/vim-table-mode'
" openai codex
" Plug 'tom-doerr/vim_codex'
call plug#end()

" vim-man (built-in)
:runtime ftplugin/man.vim

" SETTINGS
" coc
if executable('node')
  source $NORMEN/.vim/coc.vim
  augroup normensplugins
    autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
  augroup END
else
  source $NORMEN/.vim/nococ.vim
endif
" vifm
let g:vifm_embed_term=1
" vimwiki
let g:vimwiki_list = [{'path': '$NORMEN/vimwiki/', 'syntax': 'markdown', 'ext': '.md' }]
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0
" signify
nnoremap <Leader>hu :SignifyHunkUndo<CR>
nnoremap <Leader>hd :SignifyHunkDiff<CR>
let g:signify_sign_change='~'
" drawit
let g:drawit_mode='S'
" table-mode
let g:table_mode_corner='|' " markdown
" lightline
set laststatus=2 " to fix lightline
set noshowmode " don't show mode with lightline enabled
let g:lightline = { 
  \ 'colorscheme': 'gruvbox', 
  \ 'active': {
  \   'left': [
  \             [ 'mode', 'paste' ],
  \             [ 'gitstatus' ],
  \             [ 'readonly', 'relativepath', 'modified' ],
  \           ],
  \   'right': [ 
  \              [ 'filetype' ],
  \              [ 'percent' ],
  \              [ 'lineinfo' ],
  \              [ 'fileencoding' ],
  \              [ 'fileformat' ],
  \              [ 'spell' ],
  \              [ 'cocstatus' ],
  \           ],
  \ },
  \ 'inactive': {
  \   'left': [
  \             [ 'filename' ],
  \           ],
  \   'right': [ 
  \              [ 'filetype' ],
  \              [ 'percent' ],
  \           ],
  \ },
  \ 'component_function': {
  \   'gitstatus': 'FugitiveHead',
  \   'cocstatus': 'coc#status',
  \ },
  \ 'component': {
\   'lineinfo': '%3l:%-2v%<',
\ },
\ }
" tmuxline
"let g:tmuxline_powerline_separators = 0
"let g:tmuxline_separators = {
    "\ 'left' : '',
    "\ 'left_alt': '',
    "\ 'right' : '',
    "\ 'right_alt' : '',
    "\ 'space' : ' '}

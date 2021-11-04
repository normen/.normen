" PLUGINS
call plug#begin('~/.normen/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
"Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
" core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdcommenter'
" git
Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
" tools
Plug 'tpope/vim-dispatch'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'vim-utils/vim-man'
" tmux
Plug 'tpope/vim-tbone'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'wellle/tmux-complete.vim'
" coc
Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
" maptool ft
Plug 'normen/mtgvim', { 'for': 'mtmacro' }
" openscad ft
Plug 'Lattay/vim-openscad', { 'for': 'openscad' }
" hex mode
Plug 'fidian/hexmode'
call plug#end()
source ~/.normen/.vim/coc.vim

" SETTINGS
" vifm
let g:vifm_embed_term=1
" vimwiki
let g:vimwiki_list = [{'path': '~/.normen/vimwiki/', 'syntax': 'markdown', 'ext': '.md', "nested_syntaxes": {'javascript':'javascript','bash':'bash','sh':'sh','c++':'cpp','python':'python','go':'go'}}]
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0
" signify
nnoremap <Leader>hu :SignifyHunkUndo<CR>
nnoremap <Leader>hd :SignifyHunkDiff<CR>
let g:signify_sign_change='~'
" lightline
set laststatus=2 " to fix lightline
set noshowmode " don't show mode with lightline enabled
let g:lightline = { 
  \ 'colorscheme': 'gruvbox', 
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'spell', 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
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
" hexmode
let g:hexmode_xxd_options = '-g 1'
augroup normensplugins
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup END


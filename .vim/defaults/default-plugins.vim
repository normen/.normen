" PLUGINS
" built-in
:runtime ftplugin/man.vim
" Plug
silent! call plug#begin('$NORMEN/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
" core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'preservim/nerdcommenter'
Plug 'vim-scripts/visual-increment'
" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" tools
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-table-mode'
Plug 'sotte/presenting.vim'
Plug 'normen/DrawIt'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
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
" filetypes (no-coc)
Plug 'normen/mtgvim', { 'for': 'mtmacro' }
Plug 'Lattay/vim-openscad', { 'for': 'openscad' }
Plug 'fidian/hexmode'
Plug 'normen/vim-pio'
call plug#end()

" SETTINGS
colorscheme gruvbox
" gruvbox
let g:gruvbox_transparent_bg=1
" vifm
let g:vifm_embed_term=1
" vimwiki
let g:vimwiki_list = [{'path': '$NORMEN/vimwiki/', 'syntax': 'markdown', 'ext': '.md' }]
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_global_ext = 0
" signify
let g:signify_sign_change='~'
" drawit
let g:drawit_mode='S'
" table-mode
let g:table_mode_corner='|' " markdown
" limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
" tmuxline
let g:tmuxline_theme = 'lightline'

" lightline
set laststatus=2 " to fix lightline
set noshowmode " don't show mode with lightline enabled
let g:lightline = { 
  \ 'colorscheme': 'gruvbox', 
  \ 'active': {
  \   'left': [
  \             [ 'mode', 'paste', 'drawit_mode', 'table_mode'],
  \             [ 'gitstatus', 'readonly' ],
  \             [ 'relativepath', 'modified' ],
  \           ],
  \   'right': [ 
  \              [ 'filetype' ],
  \              [ 'percentwin' ],
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
  \              [ 'percentwin' ],
  \           ],
  \ },
  \ 'component_function': {
  \   'gitstatus': 'FugitiveHead',
  \   'cocstatus': 'coc#status',
  \   'drawit_mode': 'DrawItMode',
  \   'table_mode': 'TableMode',
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

" MAPPINGS
" signify
nnoremap <Leader>hu :SignifyHunkUndo<CR>
nnoremap <Leader>hd :SignifyHunkDiff<CR>
" vimwiki
nmap <Leader>wv :50vsplit<CR><Leader>ww
nmap <Leader>w<Leader>v :50vsplit<CR><Leader>w<Leader>w
" t-bone
nnoremap <Leader>tt :Twrite top<CR>
nnoremap <Leader>tb :Twrite bottom<CR>
nnoremap <Leader>tl :Twrite left<CR>
nnoremap <Leader>tr :Twrite right<CR>
vnoremap <Leader>tt :Twrite top<CR>
vnoremap <Leader>tb :Twrite bottom<CR>
vnoremap <Leader>tl :Twrite left<CR>
vnoremap <Leader>tr :Twrite right<CR>

" OTHER
" goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowcmd
  Limelight
endfunction
function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showcmd
  Limelight!
  hi! Normal guibg=NONE ctermbg=NONE
endfunction
augroup goyoplugin
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END
" coc
if executable('node')
  source $NORMEN/.vim/coc.vim
  augroup normensplugins
    autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
  augroup END
else
  source $NORMEN/.vim/nococ.vim
endif

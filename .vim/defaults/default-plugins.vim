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
"if executable('node')
  "Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
"endif
" language server / completion
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
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
" asyncomplete
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
" vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [x <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]x <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    let g:lsp_format_sync_timeout = 1000
    let g:lsp_diagnostics_signs_enabled = 0
    let g:lsp_document_code_action_signs_enabled = 0
    let g:asyncomplete_auto_popup = 0
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
if executable('ccls')
  let g:lsp_settings = {
		\  'clangd': {'disabled': v:true}
		\}
	au User lsp_setup call lsp#register_server({
		\ 'name': 'ccls',
		\ 'cmd': {server_info->['ccls']},
		\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.ccls'))},
		\ 'initialization_options': {'cache': {'directory': expand('/tmp/ccls') }},
		\ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
		\ })
endif

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
"if executable('node')
  "source $NORMEN/.vim/coc.vim
  "augroup normensplugins
    "autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
  "augroup END
"else
  "source $NORMEN/.vim/nococ.vim
"endif


" PLUGINS
" Plug
silent! call plug#begin('$NORMEN/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
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
Plug 'ojroques/vim-oscyank'
Plug 'dbeniamine/cheat.sh-vim'
" build systems
Plug 'normen/vim-pio'
" filetypes (no lsp)
Plug 'normen/mtgvim', { 'for': 'mtmacro' }
Plug 'Lattay/vim-openscad', { 'for': 'openscad' }
Plug 'luisjure/csound-vim', { 'for': 'csound' }
Plug 'kunstmusik/csound-repl', { 'for': 'csound' }
Plug 'fidian/hexmode'
if executable('openai')
  Plug 'tom-doerr/vim_codex'
endif
" lsp / completion
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
" tmux
if executable('tmux')
  Plug 'tpope/vim-tbone'
  Plug 'christoomey/vim-tmux-navigator'
  if v:versionlong < 8022345
    Plug 'tmux-plugins/vim-tmux-focus-events'
  endif
  Plug 'roxma/vim-tmux-clipboard'
  Plug 'wellle/tmux-complete.vim'
endif
call plug#end()

" fix focus events
if v:versionlong >= 8022345
  let &t_fe = "\<Esc>[?1004h"
  let &t_fd = "\<Esc>[?1004l"
  execute "set <FocusGained>=\<Esc>[I"
  execute "set <FocusLost>=\<Esc>[O"
endif

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
" cheat.sh
let g:CheatSheetDoNotMap=1
let g:CheatDoNotReplaceKeywordPrg=1
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
" asyncomplete
let g:asyncomplete_auto_popup = 0
let g:asyncomplete_auto_completeopt = 0
" vim-lsp
let g:lsp_format_sync_timeout = 1000
let g:lsp_diagnostics_signs_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_work_done_progress_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_settings_enable_suggestions = 0
" vsnip
let g:vsnip_snippet_dir = '$NORMEN/.vim/templates/snippets'

" lightline
set laststatus=2 " to fix lightline
set noshowmode " don't show mode with lightline enabled
let g:lightline = { 
  \ 'colorscheme': 'gruvbox', 
  \ 'active': {
  \   'left': [ [ 'mode', 'paste', 'drawit_mode', 'table_mode'],
  \             [ 'gitstatus', 'readonly' ],
  \             [ 'relativepath', 'modified' ], ],
  \   'right': [ [ 'filetype' ],
  \              [ 'percentwin' ],
  \              [ 'lineinfo' ],
  \              [ 'fileencoding' ],
  \              [ 'fileformat' ],
  \              [ 'spell' ],
  \              [ 'lspstatus', 'lspdiags' ], ],
  \ },
  \ 'inactive': {
  \   'left': [ [ 'filename' ], ],
  \   'right': [ [ 'filetype' ],
  \              [ 'percentwin' ], ],
  \ },
  \ 'component_function': {
  \   'gitstatus': 'FugitiveHead',
  \   'lspstatus': 'MyLspProgress',
  \   'drawit_mode': 'DrawItMode',
  \   'table_mode': 'TableMode',
  \ },
  \ 'component_expand': {
  \   'lspdiags': 'MyLspDiags',
  \ },
  \ 'component_type': {
  \   'lspdiags': 'error',
  \ },
  \ 'component': {
  \   'lineinfo': '%3l:%-2v%<',
  \ },
\ }

" MAPPINGS
" Goyo
nnoremap <C-g> :Goyo<CR>
" signify
nnoremap <Leader>hu :SignifyHunkUndo<CR>
nnoremap <Leader>hd :SignifyHunkDiff<CR>
" vimwiki
nmap <Leader>wv :50vsplit<CR><Leader>ww
nmap <Leader>w<Leader>v :50vsplit<CR><Leader>w<Leader>w
" cheat.sh
nnoremap <script> <silent> <leader>KK
      \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 0, '!')<CR>
vnoremap <script> <silent> <leader>KK
      \ :call cheat#cheat("", -1, -1, 2, 0, '!')<CR>
" t-bone
nnoremap <Leader>tt :Twrite top<CR>
nnoremap <Leader>tb :Twrite bottom<CR>
nnoremap <Leader>tl :Twrite left<CR>
nnoremap <Leader>tr :Twrite right<CR>
vnoremap <Leader>tt :Twrite top<CR>
vnoremap <Leader>tb :Twrite bottom<CR>
vnoremap <Leader>tl :Twrite left<CR>
vnoremap <Leader>tr :Twrite right<CR>
" codex
nnoremap  <C-x><C-i> :CreateCompletion<CR>
inoremap  <C-x><C-i> <Esc>li<C-g>u<Esc>l:CreateCompletion<CR>
" asyncomplete / vsnip
imap <silent><expr> <TAB>
  \ vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' :
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
imap <silent><expr> <S-TAB>
  \ vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' :
  \ pumvisible() ? "\<C-p>" :
  \ <SID>check_back_space() ? "\<S-TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
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
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

" AUTOCOMMANDS
" lsp
augroup lsp_install
  au!
  " vim-lsp keys
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  " ccls for vim-lsp
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
augroup END

" goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  let g:bak_asyncomplete_popup = g:asyncomplete_auto_popup
  let g:bak_asyncomplete_opt = g:asyncomplete_auto_completeopt
  let g:asyncomplete_auto_popup = 0
  let g:asyncomplete_auto_completeopt = 0
  set scrolloff=999
  set noshowcmd
  Limelight
endfunction
function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  let g:asyncomplete_auto_popup = g:bak_asyncomplete_popup
  let g:asyncomplete_auto_completeopt = g:bak_asyncomplete_opt
  unlet g:bak_asyncomplete_popup
  unlet g:bak_asyncomplete_opt
  set scrolloff=0
  set showcmd
  SignifyEnable
  Limelight!
  hi! Normal guibg=NONE ctermbg=NONE
endfunction
augroup goyoplugin
  au!
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" HELPERS
" get drawit mode (Lightline)
function DrawItMode()
  if !exists("b:dodrawit") | return '' | endif
  return b:dodrawit && b:di_erase ? "ERASE" : b:dodrawit ? "DRAW" : ""
endfunction

" get table mode (Lightline)
function TableMode()
  return exists("*tablemode#IsActive") && tablemode#IsActive() ? "TABLE" : ""
endfunction

" get lsp status (Lightline)
function! MyLspProgress() abort
  if !exists("*lsp#get_progress") | return '' | endif
  let progress = lsp#get_progress()
  if empty(progress) | return '' | endif
  let myprog = progress[0]
  return '[' . get(myprog,'server') . '] ' . get(myprog,'title') . ' ' . get(myprog,'message') . ' (' . get(myprog,'percentage') . '%)'
endfunction
function! MyLspDiags() abort
  if !exists("*lsp#get_buffer_diagnostics_counts") | return '' | endif
  let ret = ''
  let diags = lsp#get_buffer_diagnostics_counts()
  let errnum = get(diags,"error")
  if errnum > 0 | let ret .= errnum . '!' | endif
  return ret
endfunction
augroup my_lightline_lsp
  autocmd!
  autocmd User lsp_progress_updated call lightline#update()
  autocmd User lsp_diagnostics_updated call lightline#update()
augroup END

" check if last char is a space (Tab-complete)
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" create versionlong variable for older versions without v:verisonlong
let g:my_versionlong=get(v:, 'versionlong', v:version*10000)
let g:min_lsp_ver=9000000
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
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
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
"Plug 'Lattay/vim-openscad', { 'for': 'openscad' }
Plug 'luisjure/csound-vim', { 'for': 'csound' }
Plug 'kunstmusik/csound-repl', { 'for': 'csound' }
Plug 'fidian/hexmode'
if executable('openai')
  Plug 'tom-doerr/vim_codex'
endif
" lsp / completion
if g:my_versionlong < g:min_lsp_ver
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
else
Plug 'yegappan/lsp'
Plug 'normen/vim-lsp-settings-adapter'
endif
Plug 'mattn/vim-lsp-settings'
" snip
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
" tmux
if executable('tmux')
  Plug 'tpope/vim-tbone'
  Plug 'christoomey/vim-tmux-navigator'
  if g:my_versionlong < 8022345
    Plug 'tmux-plugins/vim-tmux-focus-events'
  endif
  Plug 'roxma/vim-tmux-clipboard'
  Plug 'wellle/tmux-complete.vim'
endif
call plug#end()

" fix focus events
if g:my_versionlong >= 8022345
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
" Fzf
nnoremap <C-f> :FZF<CR>
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
" vsnip
nmap <C-s> :VsnipShowShortcuts<CR>
imap <C-s> <C-o>:VsnipShowShortcuts<CR>
" supertab
imap <silent><expr> <TAB>
  \ vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' :
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ "\<C-x><C-o>"
imap <silent><expr> <S-TAB>
  \ vsnip#available(-1) ? '<Plug>(vsnip-expand-or-jump)' :
  \ pumvisible() ? "\<C-p>" :
  \ <SID>check_back_space() ? "\<S-TAB>" :
  \ "\<C-x><C-o>"
" handled by lsp
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
imap <c-space> <C-x><C-o>
" lsp (vim9)
function! s:on_lsp_enabled() abort
  setlocal omnifunc=LspOmniFunc
	setlocal tagfunc=lsp#lsp#TagFunc
  nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gs <Cmd>LspSymbolSearch<CR>
  nnoremap <buffer> gr <Cmd>LspShowReferences<CR>
  nnoremap <buffer> gi <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> gt <Cmd>LspGotoTypeDef<CR>
  nnoremap <buffer> <Leader>rn <Cmd>LspRename<CR>
  nnoremap <buffer> <Leader>fx <Cmd>LspCodeAction<CR>
  nnoremap <buffer> [x <Cmd>LspDiagPrev<CR><Cmd>LspDiagCurrent<CR>
  nnoremap <buffer> ]x <Cmd>LspDiagNext<CR><Cmd>LspDiagCurrent<CR>
  augroup format_on_save
    au!
    autocmd! BufWritePre *.rs,*.go call execute('LspFormat')
  augroup END
endfunction
" vim-lsp
function! s:on_vim_lsp_enabled() abort
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
  augroup format_on_save
    au!
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
  augroup END
endfunction

" AUTOCOMMANDS
augroup plugin_autocommands
  au!
  " vim-lsp
  autocmd User lsp_progress_updated call lightline#update()
  autocmd User lsp_diagnostics_updated call lightline#update()
  autocmd User lsp_buffer_enabled call s:on_vim_lsp_enabled()
  " lsp
  if g:my_versionlong > g:min_lsp_ver
  autocmd User LspDiagsUpdated call lightline#update()
  autocmd User LspAttached call s:on_lsp_enabled()
  "autocmd VimEnter * call LspOptionsSet({'showDiagOnStatusLine': v:true})
  "autocmd VimEnter * call LspOptionsSet({'autoComplete': v:false})
  autocmd VimEnter * call LspOptionsSet({'showDiagInPopup': v:true})
  "autocmd VimEnter * call LspOptionsSet({'autoHighlightDiags': v:false})
  autocmd VimEnter * call LspOptionsSet({'ignoreMissingServer': v:true})
  autocmd VimEnter * call LspOptionsSet({'noNewlineInCompletion': v:true})
  autocmd VimEnter * call LspOptionsSet({'usePopupInCodeAction': v:true})
  autocmd VimEnter * call LspOptionsSet({'snippetSupport': v:true})
  endif
  " goyo
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" add openscad to LSP
if executable($HOME.'/.cargo/bin/openscad-lsp')
  let lspServers = [
        \     #{
        \  filetype: ['openscad'],
        \  path: $HOME.'/.cargo/bin/openscad-lsp',
        \  args: ['--stdio']
        \      }
        \   ]
  "autocmd VimEnter * call LspAddServer(lspServers)
  call lsp#lsp#AddServer(lspServers)
endif

" add ccls to LSP
if executable('ccls')
augroup ccls_register
  au!
  if g:my_versionlong < g:min_lsp_ver
    " vim-lsp
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
  else
    " vim9 lsp
    let lspServers = [
          \     #{
          \  filetype: ['c', 'cpp'],
          \  path: 'ccls',
          \      }
          \   ]
    "autocmd VimEnter * call LspAddServer(lspServers)
    call lsp#lsp#AddServer(lspServers)
  endif
augroup END
endif

" goyo helpers
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  let g:bak_asyncomplete_popup = g:asyncomplete_auto_popup
  let g:bak_asyncomplete_opt = g:asyncomplete_auto_completeopt
  let g:asyncomplete_auto_popup = 0
  let g:asyncomplete_auto_completeopt = 0
  call LspOptionsSet({'autoComplete': v:false})
  "call LspOptionsSet({'autoHighlightDiags': v:false})
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
  call LspOptionsSet({'autoComplete': v:true})
  "call LspOptionsSet({'autoHighlightDiags': v:true})
  SignifyEnable
  Limelight!
  hi! Normal guibg=NONE ctermbg=NONE
endfunction

" show vsnip shortcut list
:command! VsnipShowShortcuts call <SID>ShowVsnipShortcuts()
function! s:ShowVsnipShortcuts()
  let l:sources = vsnip#source#find(bufnr('%'))
  let l:prefixes = []
  " Search prefix
  for l:source in l:sources
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        call add(l:prefixes, l:prefix . ' - ' . l:snippet.label)
      endfor
    endfor
  endfor
  call popup_atcursor(l:prefixes,{})
endfunction

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
  let ret = ''
  let errnum = 0
  if exists("*lsp#get_buffer_diagnostics_counts")
    let diags = lsp#get_buffer_diagnostics_counts()
    let errnum = get(diags,"error")
  elseif exists("*lsp#lsp#ErrorCount")
    let diags = lsp#lsp#ErrorCount()
    let errnum = get(diags,"Error")
  endif
  if errnum > 0 | let ret .= errnum . '!' | endif
  return ret
endfunction

" check if last char is a space (Tab-complete)
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


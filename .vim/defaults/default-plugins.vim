call plug#begin('~/.normen/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
" core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdcommenter'
" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
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
Plug 'neoclide/coc.nvim'
" maptool
Plug 'rkathey/mtgvim'
call plug#end()
source ~/.normen/.vim/coc.vim
let g:airline_powerline_fonts = 1
"let g:tmuxline_powerline_separators = 0
"let g:tmuxline_separators = {
    "\ 'left' : '',
    "\ 'left_alt': '',
    "\ 'right' : '',
    "\ 'right_alt' : '',
    "\ 'space' : ' '}
augroup normensplugins
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup END


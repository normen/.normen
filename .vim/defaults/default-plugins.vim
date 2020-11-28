call plug#begin('~/.normen/.vim/plugged')
" visuals
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
" core
Plug 'https://tpope.io/vim/surround'
Plug 'preservim/nerdcommenter'
" git
Plug 'https://tpope.io/vim/fugitive'
Plug 'airblade/vim-gitgutter'
" tools
Plug 'https://tpope.io/vim/dispatch'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'vim-utils/vim-man'
" tmux
Plug 'https://tpope.io/vim/tbone'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'wellle/tmux-complete.vim'
" coc
Plug 'neoclide/coc.nvim'
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

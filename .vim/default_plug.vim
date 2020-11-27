call plug#begin('~/.normen/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdcommenter'
"Plug 'fatih/vim-go'
Plug 'airblade/vim-gitgutter'
Plug 'https://tpope.io/vim/fugitive'
Plug 'https://tpope.io/vim/surround'
Plug 'https://tpope.io/vim/tbone'
Plug 'https://tpope.io/vim/dispatch'
Plug 'vim-airline/vim-airline'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'edkolev/tmuxline.vim'
Plug 'neoclide/coc.nvim'
call plug#end()
source ~/.normen/.vim/coc.vim
"let g:tmuxline_powerline_separators = 0
augroup normensplugins
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup END

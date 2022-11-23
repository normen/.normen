setlocal textwidth=2147483647
setlocal wrap!
setlocal laststatus=0
setlocal noruler
setlocal noshowmode
setlocal noshowcmd
setlocal norelativenumber
setlocal nonumber
setlocal nofoldenable
setlocal showmode
"nmap gx :!open -a qutebrowser "<cWORD>"<CR><CR>
"vmap gx y:!open -a qutebrowser "<C-r>""<CR><CR>
nmap gm :!aerc mailto:<cWORD><CR><CR>
vmap gm y:!aerc mailto:<C-r>"<CR><CR>

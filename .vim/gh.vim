"command! -nargs=+ GH call s:RunShellCommand('gh ' . <q-args>)
command! -nargs=+ GH  call s:OpenTermOnce('gh ' . <q-args>, "GitHub CLI")
command! -nargs=+ NPM  call s:OpenTermOnce('npm ' . <q-args>, "NPM Package Manager")
command! -nargs=+ GO  call s:OpenTermOnce('go ' . <q-args>, "GO Tool")
"command! -nargs=+ GH execute 'terminal gh '.<q-args>
command! GHNewIssue :terminal gh issue create
command! GHIssueList call s:RunShellCommand('gh issue list')
":let mycmd = input("Enter a command: ", "", "command")
"
function! s:OpenTermOnce(command, buffername)
  let bufnr = bufwinnr(a:buffername)
  if(bufnr>0)
    execute 'bd '.bufnr
  endif
  call term_start(a:command,{'term_name':a:buffername}) 
endfunction  

function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  bo new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  "call setline(1, 'You entered:    ' . a:cmdline)
  "call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  "call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  "1
endfunction

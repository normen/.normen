" custom commands
:command W w
" ai
vnoremap <Leader>ix :!$NORMEN/bin/gptj-universal<CR>
vnoremap <Leader>ip :!$NORMEN/bin/gptj-python<CR>

:command -nargs=* Search :vim /<args>/g %<bar>cw
:command -nargs=* SearchFiles :vim /<args>/g **/*<bar>cw
:command FixLineEndings :%s//\r/g
:command FixAdditionalLineEndings :%s///g
:command FixTrailingWhitespace :%s/\s\+$//e
:command FormatJSON :%!python -m json.tool

:command HbUploadPlugin !rsync -azrv --delete ${PWD} pi@homebridge.local:~/npm-code/
:command HbDownloadPlugin !rsync -azrv --delete pi@homebridge.local:~/npm-code/${PWD\#\#*/} ~/Dev/NodeCode/homebridge/npm-code/
:command HbFullUpload !rsync -azrv --delete ~/Dev/NodeCode/homebridge/npm-code pi@homebridge.local:~/
:command HbFullDownload !rsync -azrv --delete pi@homebridge.local:~/npm-code ~/Dev/NodeCode/homebridge/

:command GoUploadPlugin !rsync -azrv --delete ${PWD} pi@homebridge.local:~/go-code/
:command GoDownloadPlugin !rsync -azrv --delete pi@homebridge.local:~/go-code/${PWD\#\#*/} ~/Dev/GoCode/homebridge/go-code/
:command GoFullUpload !rsync -azrv --delete ~/Dev/GoCode/homebridge/go-code pi@homebridge.local:~/
:command GoFullDownload !rsync -azrv --delete pi@homebridge.local:~/go-code ~/Dev/GoCode/homebridge/

:command BackupDev !rsync -azrv --delete ~/Dev normen@normenhansen.de:~/backup/MacBook
:command RestoreDevDry !rsync -n -azrv --delete normen@normenhansen.de:~/backup/MacBook/Dev ~/

:command WebAppUp !set -e;cd client;npm run build;cd ..;git add -A;git commit -m 'update';git push -u -f origin master

:command GoCreateMakefile !cp $NORMEN/.vim/templates/Go-Makefile ./Makefile

:command JSCompletionEnable !cp $NORMEN/.vim/templates/jsconfig.json ./

:command SCADOpen !openscad %&
:command SCADExport Start openscad -o %:r.stl %
:command SCADPrint Start openscad -o %:r.stl %;open %:r.stl

command! -nargs=+ -complete=file Image2Ascii  call s:RunShellCommand('image2ascii -r=0.1 -f ' . <q-args> . ' -c=false')
command! -nargs=+ Figlet  call s:RunShellCommand('figlet -w 10000 ' . <q-args>)

com -range=% -nargs=* Diagram :<line1>,<line2>call Diagram(<q-args>)
com -range=% -nargs=* GraphEasy :<line1>,<line2>call GraphEasy(<q-args>)
com -range=% -nargs=* Markdown2 :<line1>,<line2>call Markdown2(<q-args>)

command! -nargs=+ GH  call s:OpenTermOnce('gh ' . <q-args>, "GitHub CLI")
command! -nargs=+ NPM  call s:OpenTermOnce('npm ' . <q-args>, "NPM Package Manager")
command! -nargs=+ GO  call s:OpenTermOnce('go ' . <q-args>, "GO Tool")
command! GHNewIssue :terminal gh issue create
command! GHIssueList call s:RunShellCommand('gh issue list')

" Open a named Term window only once (command tools)
function! s:OpenTermOnce(command, buffername)
  let winnr = bufwinnr(a:buffername)
  if(winnr>0)
    execute 'bd! '.winbufnr(winnr)
    "execute winnr.'wincmd c'
  endif
  call term_start(a:command,{'term_name':a:buffername})
endfunction

" Run a command and show the output in a scratch window
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
  execute 'silent $read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" get graph (dot) from selection
function GraphEasy(args) range
  let tempname = tempname()
  call writefile(getline(a:firstline, a:lastline), tempname)
  bo new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  "'graph-easy --as boxart ' . expand('%') . ' ' . <q-args>
  execute 'silent $read !graph-easy --as boxart ' . a:args . ' < ' . shellescape(tempname)
  setlocal nomodifiable
  call delete(tempname)
  1
endfunction

" get diagram from selection
function Diagram(args) range
  let tempname = tempname()
  call writefile(getline(a:firstline, a:lastline), tempname)
  bo new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'silent $read !diagram -x 80 -C ' . a:args . ' < ' . shellescape(tempname)
  execute 'silent :%s/\e\[[0-9;]*[Km]//g'
  execute 'silent :%s///g'
  setlocal nomodifiable
  call delete(tempname)
  1
endfunction

" get html from markdown
function Markdown2(args) range
  let tempname = tempname()
  call writefile(getline(a:firstline, a:lastline), tempname)
  let newname = expand('%:r').'.html'
  let winnr = bufwinnr(newname)
  if(winnr>0)
    execute winnr.'wincmd w'
    execute '%d'
    noh
  else
    bo new
    execute 'file '.newname
    setlocal filetype=html nowrap
  endif
  execute 'silent $read !markdown2 --extras fenced-code-blocks ' . a:args . ' < ' . shellescape(tempname)
  call delete(tempname)
  1
endfunction

" allow toggling quick fix window
function! QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction


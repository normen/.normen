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
command! -nargs=+ PIO  call s:OpenTermOnce('platformio ' . <q-args>, "Platform IO")
command! GHNewIssue :terminal gh issue create
command! GHIssueList call s:RunShellCommand('gh issue list')


:command PIOCreateMakefile !cp $NORMEN/.vim/templates/PlatformIO-Makefile ./Makefile
:command PIORefresh !platformio project init --ide vim
:command -nargs=* PIONew call <SID>PIOBoardSelection(<q-args>)
:command -nargs=+ PIOLibrary call <SID>PIOLibrarySelection(<q-args>)
:command -nargs=1 -complete=custom,<SID>PIOBoardList PIOInit !platformio project init --ide vim --board <args>
:command -nargs=1 -complete=custom,<SID>PIOLibraryList PIOInstall !platformio lib install '<args>'

" get a list of PlatformIO boards
function s:PIOBoardList(args,L,P)
  let raw_boards=systemlist("pio boards ".a:args)
  let boards=[]
  for boardline in raw_boards
    let board_info=matchlist(boardline,'^\([^\s\t ]*\) .*Hz.*')
    if !empty(board_info)
      let name = get(board_info,1)
      let boards = boards + [name]
    endif
  endfor
  return join(boards,"\n")
endfunction

" get a list of PlatformIO boards
function s:PIOLibraryList(args,L,P)
  let all_libs = system("pio lib search ".a:args)
  let idx=0
  let hit=["jdf"]
  let libnames=[]
  while !empty(hit)
    " match 3 lib info lines:
    " Library Name
    " ============
    " #ID: 999
    let hit=matchlist(all_libs,'\n\([^\n]*\)\n=*\n#ID: \([0-9]*\)\n',0,idx)
    if !empty(hit)
      let libnames=libnames + [get(hit,1)]
      let idx=idx+1
    endif
  endwhile
  return join(libnames,"\n")
endfunction

" show a list of libraries for selection
function! s:PIOLibrarySelection(args)
  let winnr = bufwinnr('PIO Libraries')
  if(winnr>0)
    execute winnr.'wincmd w'
    setlocal noro modifiable
    execute '%d'
  else
    bo new
    file 'PIO Libraries'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    setlocal filetype=piolibraries
    nnoremap <buffer> <CR> :exec '!pio lib install "'.getline('.').'"'<CR>
  endif
  execute 'silent $read !pio lib search --noninteractive '.a:args
  setlocal ro nomodifiable
  1
endfunction

" show a list of boards for selection
function! s:PIOBoardSelection(args)
  let winnr = bufwinnr('PIO Boards')
  if(winnr>0)
    execute winnr.'wincmd w'
    setlocal noro modifiable
    execute '%d'
  else
    bo new
    file 'PIO Boards'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    setlocal filetype=pioboards
    nnoremap <buffer> <CR> :exec '!pio init --ide vim --board '.expand('<cWORD>')<CR>
  endif
  execute 'silent $read !pio boards '.a:args
  setlocal ro nomodifiable
  1
endfunction

" Open a named Term window only once (command tools)
function! s:OpenTermOnce(command, buffername)
  let winnr = bufwinnr(a:buffername)
  if(winnr>0)
    execute winnr.'wincmd c'
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

" get drawit mode (Lightline)
function DrawItMode()
  if exists("b:dodrawit") && b:dodrawit == 1
    return "DRAW"
  else
    return ""
  endif
endfunction

" get table mode (Lightline)
function TableMode()
  if exists("*tablemode#IsActive") && tablemode#IsActive()
    return "TABLE"
  endif
  return ""
endfunction

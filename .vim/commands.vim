" custom commands
:command W w

" ai
vnoremap <Leader>ix :!$NORMEN/bin/gptj-universal<CR>
vnoremap <Leader>ip :!$NORMEN/bin/gptj-python<CR>

" tools
:command -nargs=* Search :vim /<args>/g %<bar>cw
:command -nargs=* SearchFiles :vim /<args>/g **/*<bar>cw
:command FixLineEndings :%s//\r/g
:command FixAdditionalLineEndings :%s///g
:command FixTrailingWhitespace :%s/\s\+$//e
:command FormatJSON :%!python -m json.tool
:command FormatOnSave :autocmd BufWritePre <buffer> LspDocumentFormatSync
:command TextModeGer :set spell|:set spelllang=de_de|:set wrap
:command TextModeUS :set spell|:set spelllang=en_us|:set wrap
:command! -nargs=+ Wiki call <SID>OpenTermOnce(expand('~/.normen/bin/wikigrab') . ' ' . <q-args>, "Wikipedia Search")
:command! -nargs=+ WikiNethack call <SID>OpenTermOnce(expand('~/.normen/bin/wikigrab') . ' -u https://nethackwiki.com ' . <q-args>, "NetHack Search")
:command! -nargs=+ WikiCataclysm call <SID>OpenTermOnce(expand('~/.normen/bin/wikigrab') . ' -u http://cddawiki.chezzo.com -a cdda_wiki/api.php ' . <q-args>, "Cataclysm Search")

" perl stuff
:command! PerlCtags :!ctags % -R /usr/local/lib/perl5 -R ~/perl5/lib -R .perl/lib -R ./lib
:command! -nargs=+ PerlFAQ :silent! execute 'term perldoc -q "' . <q-args> . '"'

" local
:command BackupDev !rsync -azrv --delete ~/Dev normen@normenhansen.de:~/backup/MacBook
:command RestoreDevDry !rsync -n -azrv --delete normen@normenhansen.de:~/backup/MacBook/Dev ~/
:command WebAppUp !set -e;cd client;npm run build;cd ..;git add -A;git commit -m 'update';git push -u -f origin master

" ChordPro
" cpan App::Music::ChordPro
:command ChordConvert :%!chordpro --a2crd %
:command -nargs=+ ChordTranspose :!chordpro --transpose <args> % > %:r-trans.pdf
:command ChordPrint :!chordpro %|lp
:command ChordExport :!chordpro % > %:r.pdf
":command ChordExportPDF :!chordpro % | ps2pdf - > %:r.pdf

" OpenSCAD
:command SCADOpen !openscad %&
:command SCADExport Start openscad -o %:r.stl %
:command SCADPrint Start openscad -o %:r.stl %;open %:r.stl

" NPM
command! -nargs=+ NPM  call <SID>OpenTermOnce('npm ' . <q-args>, "NPM Package Manager")
:command JSCompletionEnable !cp $NORMEN/.vim/templates/jsconfig.json ./

" go
command! -nargs=+ GO  call <SID>OpenTermOnce('go ' . <q-args>, "GO Tool")
:command GoCreateMakefile !cp $NORMEN/.vim/templates/Go-Makefile ./Makefile

" GH
command! -nargs=+ GH  call <SID>OpenTermOnce('gh ' . <q-args>, "GitHub CLI")
command! GHNewIssue :terminal gh issue create
command! GHIssueList call <SID>RunShellCommand('gh issue list')

" image2ascii (go version)
" go get github.com/qeesung/image2ascii
command! -nargs=+ -complete=file Image2Ascii exec 'read !image2ascii -r=0.1 -f ' . <q-args> . ' -c=false'

command! PerlTidy exec '%!perltidy -i=2 -l=1000 -utf8 -fbl -fnl'

" get figlet with font name completion
" brew install figlet
command! -nargs=+ -complete=custom,<SID>FigletFontList Figlet exec 'read !figlet -w 10000 ' . <q-args>
function! s:FigletFontList(args,L,P)
  echo a:args
  if a:L =~ ' -f '
    let mylist=systemlist("figlist")
    return join(mylist[3:],"\n")
  endif
  return ''
endfunction

" get graph (dot) from selection
" cpan Graph::Easy
com -range=% -nargs=* GraphEasy :<line1>,<line2>call GraphEasy(<q-args>)
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
" pip install diagram
com -range=% -nargs=* Diagram :<line1>,<line2>call Diagram(<q-args>)
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
" pip install markdown2
com -range=% -nargs=* Markdown2 :<line1>,<line2>call Markdown2(<q-args>)
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


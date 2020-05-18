# vimscript
#### use location list
```vimscript
call setloclist(0, map(systemlist('ls -a ~/'), {_, p -> {'filename': p}}))
call setloclist(...) - function call

0,(first argumet) - the target window. 0 means current window, but in your plugin you may want to set the loclist of another window.

map(...):

systemlist('ls -a ~/') - your command. I use systemlist to get a list of the lines

{_, p -> {'filename': p}} - a lambda for transforming the lines into dictionaries acceptable by setloclist()

The important part here is the lambda. It converts matches like '.vimrc' to dictionaries like {'filename': '.vimrc'}. Refer to :help setqflist() for what you can put in these dictionaries.

BTW, if you want it to work, you may need to use full paths:

{_, p -> {'filename': fnamemodify('~/' . p, ':p:.')}}
```

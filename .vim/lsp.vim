" makes vim-lsp-settings work with lsp(vim9) plugin
function! lsp#register_server(server_info) abort
    let l:server_name = a:server_info['name']
    let lspServers = [
          \     #{
          \  filetype: a:server_info["allowlist"],
          \  path: a:server_info["cmd"]("")[0],
          \  args: a:server_info["cmd"]("")[1:]
          \      }
          \   ]
    call lsp#lsp#AddServer(lspServers)
endfunction

function! lsp#register_command(command_name, callback) abort
endfunction

function! lsp#register_notifications(name, callback) abort
endfunction

function! lsp#unregister_notifications(name) abort
endfunction

function! lsp#stop_server(server_name) abort
endfunction

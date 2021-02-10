" vimtex
" assign a server name when using vim from the terminal,
" required to use the callback on the vimtex plugin
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('vimtex')
endif

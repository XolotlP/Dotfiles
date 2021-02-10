setlocal spell spelllang=en,es                      "enable spellcheck
setlocal nocindent

function GripToogle()
    execute ":silent update"
    let info = execute("command GripStop")
    if info == "\nNo user-defined commands found"
        GripStart
        echo "Grip Started"
    else
        GripStop
        echo "Grip Stopped"
    endif
endfunction

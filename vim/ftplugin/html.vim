" only 2 spaces for tabstop
setlocal tabstop=2
setlocal softtabstop=2               " Number of spaces per Tab
setlocal shiftwidth=2                " Number of auto-indent spaces

" indent folding with manual folds
setlocal foldmethod=indent
setlocal foldlevel=1
if &fdm == 'indent' | setlocal foldmethod=manual | endif

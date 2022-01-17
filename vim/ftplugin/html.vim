" indent folding with manual folds
setlocal foldmethod=indent
setlocal foldlevel=1
if &fdm == 'indent' | setlocal foldmethod=manual | endif



scriptencoding utf-8
"
if exists("g:loaded_hexript")
  finish
endif
let g:loaded_hexript = 1

let s:save_cpo = &cpo
set cpo&vim

let g:hexript_default_compile = get(g:, 'hexript_default_compile', 'xxd') 
if g:hexript_default_compile ==# 'xxd'
elseif g:hexript_default_compile ==# 'python/io'
elseif g:hexript_default_compile ==# 'python/vinarise'
else
  let g:hexript_default_compile = 'xxd' 
endif

if !exists(":HexriptToBinaryFile")
  command! -nargs=1 -complete=file HexriptToBinaryFile
  \ :call hexript#file_to_binaryfile(expand("%"),<q-args>)
endif

let &cpo = s:save_cpo
finish

" vim:  fdm=marker: ff=unix: fileencoding=utf-8

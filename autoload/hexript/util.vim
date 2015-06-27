
scriptencoding utf-8

function! hexript#util#is_number(expr) "{{{
  return type(0) == type(a:expr)
endfunction "}}}
function! hexript#util#is_string(expr) "{{{
  return type("") == type(a:expr)
endfunction "}}}
function! hexript#util#is_funcref(expr) "{{{
  return type(function("tr")) == type(a:expr)
endfunction "}}}
function! hexript#util#is_list(expr) "{{{
  return type([]) == type(a:expr)
endfunction "}}}
function! hexript#util#is_dict(expr) "{{{
  return type({}) == type(a:expr)
endfunction "}}}
function! hexript#util#is_float(expr) "{{{
  return type(0.0) == type(a:expr)
endfunction "}}}

function! hexript#util#replace_elem(list,idx,elems) "{{{
  " echo s:replace_elem([1,2,3],0,[])
  " [2,3]
  " echo s:replace_elem([1,2,3],1,[4,5])
  " [1,4,5,3]

  if a:idx == 0
    let head = []
    let tail = a:list[(a:idx+1):]
  elseif a:idx == len(a:list) - 1
    let head = a:list[:(a:idx-1)]
    let tail = []
  elseif a:idx == len(a:list) - 1
  else
    let head = a:list[:(a:idx-1)]
    let tail = a:list[(a:idx+1):]
  endif
  return head + a:elems + tail
endfunction "}}}
function! hexript#util#remove_tmpfile(tmp_fname) "{{{
  if filereadable(a:tmp_fname)
    call delete(a:tmp_fname)
  endif
endfunction "}}}

" vim: set ft=vim fdm=marker ff=unix :

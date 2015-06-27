
scriptencoding utf-8

function! s:search_tuples() "{{{
  let tuples_list = split(globpath(&rtp,'autoload/hexript/tuples/**/*.vim')."\n")
  call map(tuples_list,'substitute(substitute(v:val,"\\","/","g"),''^.*autoload/hexript/tuples/\(.*\)\.vim$'',''\1'',"")')
  call map(tuples_list,'[substitute(v:val,"/",".","g"),function("hexript#tuples#" . substitute(v:val,"/","#","g") . "#new")]')
  let tuples_dict = {}
  for t in tuples_list
    let tuples_dict[t[0]] = t[1]
  endfor
  return tuples_dict
endfunction "}}}
let s:tuples = s:search_tuples()

function! s:function_of_tuple(tuple_name) "{{{
  return s:tuples[(a:tuple_name)]
endfunction "}}}

function! hexript#resolver#reference_at(tkns,idx) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = a:idx
  let tkns[idx].visited = 1
  let pointer = str2nr(tkns[idx].matched_text[1:],16)
  if pointer >= len(tkns)
    call hexript#exception('out of range.', hexript#callstack())
  elseif has_key(tkns[pointer],'visited')
    call hexript#exception('circular reference.',hexript#callstack())
  elseif hexript#core#is_reference(tkns[pointer])
    let tkns = hexript#resolver#reference_at(tkns,pointer)
  elseif hexript#core#is_tuple(tkns[pointer])
    let tkns = hexript#resolver#tuple_at(tkns,pointer)
  elseif hexript#core#is_numeric(tkns[pointer])
    " do nothing
  else
    call hexript#exception('do not improved type.', hexript#callstack())
  endif
  if hexript#core#is_numeric(tkns[pointer])
    let tkns[idx] = tkns[pointer]
  else
    call hexript#exception('can not resolve reference.',hexript#callstack())
  endif
  return tkns
endfunction "}}}
function! hexript#resolver#reference_all(tkns) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = 0
  while idx < len(tkns)
    if hexript#core#is_reference(tkns[idx])
      let tkns = hexript#resolver#reference_at(tkns,idx)
    endif
    let idx += 1
  endwhile
  return tkns
endfunction "}}}
function! hexript#resolver#tuple_at(tkns,idx) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = a:idx
  let tkns[idx].visited = 1
  if hexript#core#is_reference(tkns[idx])
    let tkns = hexript#resolver#reference_at(tkns,idx)
  elseif hexript#core#is_tuple(tkns[idx])
    let F = s:function_of_tuple(tkns[idx].matched_text[0].matched_text)
    let tkns = hexript#util#replace_elem(tkns,idx,F(tkns[idx]))
  elseif hexript#core#is_numeric(tkns[idx])
    " do nothing
  else
    call hexript#exception('do not improved type.', hexript#callstack())
  endif
  return tkns
endfunction "}}}
function! hexript#resolver#tuple_all(tkns) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = 0
  while idx < len(tkns)
    if hexript#core#is_tuple(tkns[idx])
      let tkns = hexript#resolver#tuple_at(tkns,idx)
    endif
    let idx += 1
  endwhile
  return tkns
endfunction "}}}
function! hexript#resolver#until_become_numeric_at(tkns,idx) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = a:idx
  while ! hexript#core#is_numeric(tkns[idx])
    if hexript#core#is_reference(tkns[idx])
      let tkns = hexript#resolver#reference_at(tkns,idx)
    elseif hexript#core#is_tuple(tkns[idx])
      let tkns = hexript#resolver#tuple_at(tkns,idx)
    elseif hexript#core#is_numeric(tkns[idx])
      break
    else
      call hexript#exception('do not improved type.', hexript#callstack())
    endif
  endwhile
  return tkns
endfunction "}}}
function! hexript#resolver#until_become_numeric_all(tkns) "{{{
  let tkns = deepcopy(a:tkns)
  let idx = 0
  while idx < len(tkns)
    let tkns = hexript#resolver#until_become_numeric_at(tkns,idx)
    let idx += 1
  endwhile
  return tkns
endfunction "}}}

" vim: set ft=vim fdm=marker ff=unix :

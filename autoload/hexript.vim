
scriptencoding utf-8

function! hexript#callstack() " {{{
  try
    throw 'abc'
  catch /^abc$/
    return split(matchstr(v:throwpoint, 'function \zs.*\ze,.*'), '\.\.')[ : -2]
  endtry
endfunction " }}}
function! hexript#exception(msg,callstack,...) "{{{
  throw printf('[Hexript] %s', string(a:callstack[-1]) )
endfunction "}}}

function! hexript#file_to_dict(source) "{{{
  let dict = {
  \   "bytes" : []
  \ , "error_occurred" : 0
  \ }

  let tmp_pwd = getcwd()
  let filepath = fnamemodify(a:source, ":p")
  execute "cd " . fnamemodify(filepath, ":p:h")

  try
    let tkns = hexript#core#file_to_tokens(filepath)

    " PP (tkns)

    let tkns = hexript#resolver#until_become_numeric_all(tkns)

    " PP (tkns)

      " resolve Numeric to Bytes {{{
      let idx = 0
      while len(tkns) > idx
        let tkn = tkns[idx]
        if hexript#util#is_dict(tkn)
          if hexript#core#is_numeric(tkns[idx])
            if len(tkn.matched_text) == 2
              let tkns = hexript#util#replace_elem(tkns,idx,[str2nr(tkn.matched_text,16)])
            elseif len(tkn.matched_text) == 4
              let tkns = hexript#util#replace_elem(tkns,idx,
              \ [str2nr(tkn.matched_text[0:1],16), str2nr(tkn.matched_text[2:3],16)] )
            elseif len(tkn.matched_text) == 8
              let tkns = hexript#util#replace_elem(tkns,idx,
              \ [str2nr(tkn.matched_text[0:1],16), str2nr(tkn.matched_text[2:3],16),
              \ str2nr(tkn.matched_text[4:5],16), str2nr(tkn.matched_text[6:7],16)] )
            endif
          endif
          let idx = 0
        else
          let idx += 1
        endif
        unlet tkn
      endwhile
      " }}}

    " PP (tkns)

    let dict.bytes = tkns
  catch "[Hexript]"
    echohl Error
    echo v:exception
    echo v:throwpoint
    echohl None
    let dict["bytes"] = []
    let dict["error_occurred"] = 1
  endtry

  execute "cd " . tmp_pwd

  return dict
endfunction "}}}
function! hexript#dict_to_file(dict,dest) "{{{
  let bytes = get(a:dict,'bytes',[])
  let lines = []
  let idx = 0
  while len(bytes) > idx
    if (idx+1) % 16 == 0  || len(bytes) == (idx+1)
      let lines += [printf("// %07x:",(idx)/16*16)]
      let lines += [join(map(bytes[(idx-(idx%16)):(idx)],'printf("%02x",v:val)')," ")]
    endif
    let idx += 1
  endwhile
  call writefile(lines,a:dest)
endfunction "}}}

function! hexript#lines_to_binaryfile(lines,dest) "{{{
  let tmp = tempname()
  call writefile(a:lines,tmp)
  let parse_dict = hexript#file_to_dict(tmp)
  if filereadable(tmp)
    call delete(tmp)
  endif
  if ! parse_dict.error_occurred
    call hexript#bytes_to_binaryfile(parse_dict.bytes,a:dest)
  endif
endfunction "}}}
function! hexript#file_to_binaryfile(source,dest) "{{{
  call hexript#bytes_to_binaryfile(hexript#file_to_dict(a:source).bytes,a:dest)
endfunction "}}}

if g:hexript_default_compile ==# 'python/vinarise'
  let s:pyobj = vinarise#python#new('hexript_pyobj')
function! hexript#binaryfile_to_bytes(source) "{{{
  call s:pyobj.open(a:source)
  let bytes = s:pyobj.get_bytes(0,1000)
  call s:pyobj.close(a:source)
  return bytes
endfunction "}}}
function! hexript#bytes_to_binaryfile(bytes,dest) "{{{
  call s:pyobj.open(a:dest)
  for idx in range(0,len(a:bytes)-1)
    call s:pyobj.set_byte(idx,a:bytes[idx])
  endfor
  call s:pyobj.write(a:dest)
  call s:pyobj.close()
endfunction "}}}
elseif g:hexript_default_compile ==# 'python/io'
function! hexript#binaryfile_to_bytes(source) "{{{
  let f = python#io#open(a:source)
  return f.get_bytes(0,f.size())
endfunction "}}}
function! hexript#bytes_to_binaryfile(bytes,dest) "{{{
  let f = python#io#open(expand(a:dest))
  call f.new()
  call f.write(a:bytes)
endfunction "}}}
elseif g:hexript_default_compile ==# 'xxd'
function! hexript#binaryfile_to_bytes(source) "{{{
  return xxd#bin2bytes(a:source)
endfunction "}}}
function! hexript#bytes_to_binaryfile(bytes,dest) "{{{
  call xxd#bytes2bin(a:bytes,a:dest)
endfunction "}}}
endif

" vim: set ft=vim fdm=marker ff=unix :

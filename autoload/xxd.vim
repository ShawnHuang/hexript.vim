
scriptencoding utf-8

function! s:system(...) " {{{
  if exists('g:loaded_vimproc')
    return vimproc#system(a:1)
  else
    return system(a:1)
  endif
endfunction " }}}
function! s:print_error(msg) "{{{
  echohl Error
  echo a:msg
  echohl None
endfunction "}}}

function! xxd#lines2bytes(xxd_lines) "{{{
  let bytes = []
  for lines_bytes in map(a:xxd_lines,'split(v:val[9:47]," ")')
    for byte0_2 in lines_bytes
      if len(byte0_2) == 2
        let bytes += [byte0_2]
      elseif len(byte0_2) == 4
        let bytes += [byte0_2[0:1],byte0_2[2:3]]
      endif
    endfor
  endfor
  return map(bytes,'str2nr(v:val,16)')
endfunction "}}}
function! xxd#bytes2lines(bytes) "{{{
  let xxd_lines = []
  if len(a:bytes) > 0
    for idx in range(1,len(a:bytes))
      if idx % 16 == 0  || idx == len(a:bytes)
        let tmp_bytes = a:bytes[((idx-1)-((idx-1)%16)):(idx-1)]
        let str = ""
        for n in range(0,len(tmp_bytes)-1)
          let str .= printf('%02x',tmp_bytes[n])
          if n % 2 == 1
            let str .= " "
          endif
        endfor
        let xxd_lines += [printf("%07x: %s ",((idx-1)/16*16),str)]
      endif
    endfor
    return xxd_lines
  else
    return ["0000000: "]
  endif
endfunction "}}}

function! xxd#bin2bytes(source) "{{{
  if executable('xxd')
    if filereadable(a:source)
      let xxd_lines = s:system("xxd " . shellescape(a:source))
      return xxd#lines2bytes(split(xxd_lines,"\n"))
    else
      call s:print_error('can not read the file! ' . a:source)
    endif
  else
    call s:print_error('xxd is not executable!')
  endif
  return []
endfunction "}}}
function! xxd#bytes2bin(bytes,dest) "{{{
  if executable('xxd')
    let tmp_fname = tempname()
    call writefile(xxd#bytes2lines(a:bytes),tmp_fname)
    if filereadable(a:dest)
      call delete(a:dest)
    endif
    let cmd = 'xxd -r ' . shellescape(tmp_fname) . ' ' . shellescape(a:dest)
    let cmd = substitute(cmd,'\\','/','g')
    call s:system(cmd)
    if filereadable(tmp_fname)
      call delete(tmp_fname)
    endif
  else
    call s:print_error('xxd is not executable!')
  endif
endfunction "}}}

"  vim: set ft=vim fdm=marker ff=unix :

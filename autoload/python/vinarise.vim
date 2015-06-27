
scriptencoding utf-8

" [DEPEND]
" vinarise.py
" vinarise#print_error
" vinarise#util#iconv
" vinarise#util#is_windows
"
" {{{
let s:vinarise = {}
function! s:vinarise.open(filename) " {{{
  execute 'python' self.python.
  \ ".open(vim.eval('vinarise#util#iconv(a:filename, &encoding, \"char\")'),".
  \ "vim.eval('vinarise#util#is_windows()'))"
endfunction " }}}
function! s:vinarise.close() "{{{
  execute 'python' self.python.'.close()'
endfunction " }}}
function! s:vinarise.write(path) "{{{
  execute 'python' self.python.'.write('
  \ "vim.eval('a:path'))"
endfunction " }}}
function! s:vinarise.open_bytes(bytes) "{{{
  execute 'python' self.python.
  \ ".open(vim.eval('len(a:bytes)'),".
  \ "vim.eval('vinarise#util#is_windows()'))"
  let address = 0
  for byte in a:bytes
    call self.set_byte(address, byte)
    let address += 1
  endfor
endfunction " }}}
function! s:vinarise.get_byte(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_byte(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_bytes(address, count) "{{{
  execute 'python' 'vim.command("let bytes = " + str('.
  \ self.python .".get_bytes(vim.eval('a:address'), vim.eval('a:count'))))"
  return bytes
endfunction " }}}
function! s:vinarise.get_int8(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_int8(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_int16(address, is_little_endian) "{{{
  return a:is_little_endian ?
  \ self.get_int16_le(a:address) : self.get_int16_be(a:address)
endfunction " }}}
function! s:vinarise.get_int16_le(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_int16_le(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_int16_be(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_int16_be(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_int32(address, is_little_endian) "{{{
  return a:is_little_endian ?
  \ self.get_int32_le(a:address) : self.get_int32_be(a:address)
endfunction " }}}
function! s:vinarise.get_int32_le(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_int32_le(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_int32_be(address) "{{{
  execute 'python' 'vim.command("let num = " + str('.
  \ self.python .'.get_int32_be(vim.eval("a:address"))))'
  return num
endfunction " }}}
function! s:vinarise.get_chars(address, count, from, to) "{{{
  execute 'python' 'vim.command("let chars = ''" + str('.
  \ self.python .".get_chars(vim.eval('a:address'),"
  \ ."vim.eval('a:count'), vim.eval('a:from'),"
  \ ."vim.eval('a:to'))) + \"'\")"
  return chars
endfunction " }}}
function! s:vinarise.set_byte(address, value) "{{{
  execute 'python' self.python .
  \ '.set_byte(vim.eval("a:address"), vim.eval("a:value"))'
endfunction " }}}
function! s:vinarise.get_percentage(address) "{{{
  execute 'python' 'vim.command("let percentage = " + str('.
  \ self.python .'.get_percentage(vim.eval("a:address"))))'
  return percentage
endfunction " }}}
function! s:vinarise.get_percentage_address(percentage) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".get_percentage_address(vim.eval('a:percentage'))))"
  return address
endfunction " }}}
function! s:vinarise.find(address, str, from, to) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".find(vim.eval('a:address'), vim.eval('a:str'),"
  \ ."vim.eval('a:from'),"
  \ ."vim.eval('a:to'))))"
  return address
endfunction " }}}
function! s:vinarise.rfind(address, str, from, to) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".rfind(vim.eval('a:address'), vim.eval('a:str'),"
  \ ."vim.eval('a:from'),"
  \ ."vim.eval('a:to'))))"
  return address
endfunction " }}}
function! s:vinarise.find_regexp(address, str, from, to) "{{{
  try
    execute 'python' 'vim.command("let address = " + str('.
    \ self.python .
    \ ".find_regexp(vim.eval('a:address'), vim.eval('a:str'),"
    \ ."vim.eval('a:from'),"
    \ ."vim.eval('a:to'))))"
  catch
    call vinarise#print_error('Invalid regexp pattern!')
    return -1
  endtry

  return address
endfunction " }}}
function! s:vinarise.find_binary(address, binary) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".find_binary(vim.eval('a:address'), vim.eval('a:binary'))))"
  return address
endfunction " }}}
function! s:vinarise.rfind_binary(address, binary) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".rfind_binary(vim.eval('a:address'), vim.eval('a:binary'))))"
  return address
endfunction " }}}
function! s:vinarise.find_binary_not(address, binary) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".find_binary_not(vim.eval('a:address'), vim.eval('a:binary'))))"
  return address
endfunction " }}}
function! s:vinarise.rfind_binary_not(address, binary) "{{{
  execute 'python' 'vim.command("let address = " + str('.
  \ self.python .
  \ ".rfind_binary_not(vim.eval('a:address'), vim.eval('a:binary'))))"
  return address
endfunction " }}}
" }}}
function! s:load(objname) " {{{
  let ps = split(globpath(&rtp,'**/autoload/vinarise/vinarise.py'),"\n")
  if ! empty(ps)
    execute 'pyfile ' . ps[0]
    execute 'python ' . a:objname . ' = VinariseBuffer()'
    return a:objname
  else
    return ''
  endif
endfunction " }}}

function! vinarise#python#new(objname) " {{{
  let vinarise = deepcopy(s:vinarise)
  let vinarise['python'] = s:load(a:objname)
  return vinarise
endfunction " }}}

"  vim: set ft=vim fdm=marker ff=unix :

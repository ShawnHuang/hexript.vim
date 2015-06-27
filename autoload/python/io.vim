
scriptencoding utf-8
"
python << END
import vim
import os.path
END

let s:io = {}

function! s:io.new() " {{{
python << END
f = open(vim.eval("self.path"),"wb")
f.close()
END
  return self
endfunction " }}}
function! s:io.read(length,...) " {{{
  let address = a:0 > 0 ? a:1 : 0
python << END
f = open(vim.eval("self.path"),"rb")
f.seek(int(vim.eval("address")))
vim.command('let bs = ' + str( map((lambda x: ord(x)),f.read(int(vim.eval("a:length")))) ))
f.close()
END
  return bs
endfunction " }}}
function! s:io.write(bytes,...) " {{{
  let address = a:0 > 0 ? a:1 : 0
  let bytes = type([]) == type(a:bytes) ? a:bytes : [(a:bytes)]
python << END
f = open(vim.eval("self.path"),"r+b")
f.seek(int(vim.eval("address")))
for byte in vim.eval("bytes"):
  f.write(chr(int(byte)))
f.close()
END
  return self
endfunction " }}}
function! s:io.append(bytes) " {{{
  return self.insert(a:bytes,self.size())
endfunction " }}}
function! s:io.size() " {{{
python << END
f = open(vim.eval("self.path"),"rb")
vim.command('let size = ' + str(os.path.getsize(vim.eval("self.path"))) )
f.close()
END
  return size
endfunction " }}}
function! s:io.insert(bytes,...) " {{{
  let address = a:0 > 0 ? a:1 : 0
  let bytes = type([]) == type(a:bytes) ? a:bytes : [(a:bytes)]
python << END
size = os.path.getsize(vim.eval("self.path"))
f = open(vim.eval("self.path"),"r+b")
f.seek(int(vim.eval("address")))
bytes = map( (lambda x: chr(int(x))), vim.eval("bytes")) \
      + map( (lambda x: str(x)), f.read(size - int(vim.eval("address"))))
f.seek(int(vim.eval("address")))
for byte in bytes:
  f.write(byte)
f.close()
END
  return self
endfunction " }}}
function! s:io.resize(n) " {{{
python << END
f = open(vim.eval("self.path"),"rb")
size = os.path.getsize(vim.eval("self.path"))
bytes = f.read(size)
f.close()
f = open(vim.eval("self.path"),"wb")
for byte in bytes[:int(vim.eval("a:n"))]:
  f.write(chr(int(ord(byte))))
f.close()
END
  return self
endfunction " }}}

function! s:io.get_byte(addr) " {{{
  return self.read(1,a:addr)
endfunction " }}}
function! s:io.get_bytes(addr,cnt) " {{{
  if a:cnt <= 0
    return []
  else
    return self.read(a:cnt,a:addr)
  endif
endfunction " }}}
function! s:io.get_int8(addr) " {{{
  return self.get_byte(a:addr)
endfunction " }}}
function! s:io.get_int16_le(addr) " {{{
  let bytes = self.get_bytes(a:addr,2)
  return get(bytes,0,0) + get(bytes,1,0) * 0x100
endfunction " }}}
function! s:io.get_int16_be(addr) " {{{
  let bytes = self.get_bytes(a:addr,2)
  return get(bytes,1,0) + get(bytes,0,0) * 0x100
endfunction " }}}
function! s:io.get_int32_le(addr) " {{{
  let bytes = self.get_bytes(a:addr,4)
  return get(bytes,0,0)           + get(bytes,1,0) * 0x100
     \ + get(bytes,2,0) * 0x10000 + get(bytes,3,0) * 0x1000000
endfunction " }}}
function! s:io.get_int32_be(addr) " {{{
  let bytes = self.get_bytes(a:addr,4)
  return get(bytes,3,0)           + get(bytes,2,0) * 0x100
     \ + get(bytes,1,0) * 0x10000 + get(bytes,0,0) * 0x1000000
endfunction " }}}
function! s:io.set_byte(addr,byte) " {{{
  call self.write([a:byte])
endfunction " }}}
function! s:io.get_percentage(addr,address) " {{{
  return floor(a:address*100) / (self.size() - 1)
endfunction " }}}
function! s:io.get_percentage_address(addr,percent) " {{{
  return floor((self.size() - 1) * a:percent) / 100
endfunction " }}}

function! python#io#open(path) " {{{
  " if filereadable(expand(a:path))
    let io = deepcopy(s:io)
    let io.path = a:path
    return io
  " else
    " return {}
  " endif
endfunction " }}}

" let f = python#io#open('./b.txt')
" call f.new()
" call f.write([1,2,3,4,5])
" echo f.read(f.size())
" echo f.get_byte(1)
" echo f.get_bytes(3,2)
" echo f.get_bytes(1,3)
" echo f.get_int8(1)
" echo f.get_int16_le(2)
" echo f.get_int16_be(2)
" echo f.get_int32_le(2)
" echo f.get_int32_be(2)


"  vim: set ft=vim fdm=marker ff=unix :

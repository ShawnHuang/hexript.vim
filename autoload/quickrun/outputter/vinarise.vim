
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = {}

let s:outputter = {
\   'config': {
\     'target': '',
\   },
\ }

function! s:outputter.init(session)"{{{
  let self._result = ''
endfunction"}}}

function! s:outputter.output(data, session)"{{{
  let self._result .= a:data
endfunction"}}}

function! s:outputter.finish(session)"{{{
  let tmp_fname = tempname()
  if a:session.base_config.type ==# 'hexript'
    let fname = expand("%:p")
    if ! filereadable(fname)
      call writefile(getbufline("%",1,"$"),tmp_fname)
      let fname = tmp_fname
    endif
    let parse_dict_bytes_is_int = hexript#file_to_dict(fname)
    if ! (parse_dict_bytes_is_int.error_occurred)
      call vinarise#start("",{"split":1,"bytes":parse_dict_bytes_is_int.bytes})
    endif
  else
    call writefile(split(self._result,"\n"),tmp_fname)
    execute " Vinarise -split " . tmp_fname
  endif
  execute "autocmd VimLeave * :call hexript#util#remove_tmpfile(" . string(tmp_fname) . ")"
endfunction"}}}

function! quickrun#outputter#vinarise#new()"{{{
  return deepcopy(s:outputter)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set ft=vim fdm=marker ff=unix :

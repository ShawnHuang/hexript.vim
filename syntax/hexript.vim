
scriptencoding utf-8

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match _Numeric display /\<[0-9a-fA-F]\{2,2}\>/
syn match _Numeric display /\<[0-9a-fA-F]\{4,4}\>/
syn match _Numeric display /\<[0-9a-fA-F]\{8,8}\>/
syn match _Reference display /\$[0-9a-fA-F]\+/
syn match _Identifier /\<[a-zA-Z][.a-zA-Z]\+\>/
syn region _String start=+"+ skip=+\\"+ end=+"+
syn region _String start=+'+ skip=+''+ end=+'+
syn region _Comment start=+//+ end=+$+

hi def link _Numeric Number
hi def link _Reference Macro
hi def link _Comment Comment
hi def link _String String
hi def link _Identifier Identifier

let b:current_syntax = "hexript"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set ft=vim fdm=manual ff=unix :

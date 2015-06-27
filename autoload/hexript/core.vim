
scriptencoding utf-8

let s:V = vital#of('hexript.vim')
let s:L = s:V.import('Text.Lexer')

let s:patterns = [
\ ['Comment','//.*$'],
\ ['WhiteSpace','\s\+'],
\ ['LeftParenthese','('],
\ ['RightParenthese',')'],
\ ['Comma',','],
\ ['Numeric','\(-\|\)[0-9a-fA-F]\{8,8}'],
\ ['Numeric','\(-\|\)[0-9a-fA-F]\{4,4}'],
\ ['Numeric','\(-\|\)[0-9a-fA-F]\{2,2}'],
\ ['Reference','$[0-9a-fA-F]\+'],
\ ['String','"\(\\.\|[^"]\)*"'],
\ ['String','''\(''''\|[^'']\)*'''],
\ ['Identifier','[a-zA-Z][.a-zA-Z]\+'],
\ ]
"
function! hexript#core#token(type,value,...) "{{{
  let obj = { 'label' : a:type, 'matched_text' : a:value }
  return deepcopy(obj)
endfunction "}}}
function! hexript#core#file_to_tokens(source) "{{{
  let tkns = []
  let lex = s:L.lexer(s:patterns)
  if filereadable(a:source)
    let line_num = 1
    for line in readfile(a:source)
      let tkns += lex.parse(line)
      let line_num += 1
    endfor
  else
    call hexript#exception('can not read file! ' . a:source,{},hexript#callstack())
  endif

  let parser_obj = s:L.simple_parser(tkns)
  function! parser_obj.ignore() dict "{{{
    if self.next_is('WhiteSpace') || self.next_is('Comment')
      call self.consume()
    endif
    return self
  endfunction "}}}
  function! parser_obj.element() dict "{{{
    let tokens = []
    call self.ignore()
    if self.next_is('LeftParenthese')
      call self.consume()
      let tokens += [self.tuple()]
    elseif self.next_is('Numeric')
      let tokens += [self.next()]
      call self.consume()
    elseif self.next_is('Reference')
      let tokens += [self.next()]
      call self.consume()
    elseif self.next_is('String')
      let tokens += [self.next()]
      call self.consume()
    elseif self.next_is('Identifier')
      let tokens += [self.next()]
      call self.consume()
    elseif ! self.end()
      call hexript#exception('syntax error.',hexript#callstack())
    endif
    call self.ignore()
    return tokens
  endfunction "}}}
  function! parser_obj.tuple() dict "{{{
    let tokens = []
    let tmp = self.element()
    while ! empty(tmp)
      let tokens += tmp

      if self.next_is('RightParenthese')
        call self.consume()
        break
      elseif self.next_is('Comma')
        call self.consume()
      else
        call hexript#exception('syntax error.',hexript#callstack())
      endif

      let tmp = self.element()
    endwhile

    if empty(tokens) || tokens[0].label ==# 'Identifier'
      return hexript#core#token('Tuple',tokens)
    else
      call hexript#exception('syntax error.', hexript#callstack())
    endif
  endfunction "}}}
  while ! parser_obj.end()
    let parser_obj.tokens += parser_obj.element()
  endwhile
  return parser_obj.tokens
endfunction "}}}

" {{{
function! hexript#core#is_string(tkn) "{{{
  return 'String' ==# a:tkn.label
endfunction "}}}
function! hexript#core#is_tuple(tkn) "{{{
  return 'Tuple' ==# a:tkn.label
endfunction "}}}
function! hexript#core#is_numeric(tkn) "{{{
  return 'Numeric' ==# a:tkn.label
endfunction "}}}
function! hexript#core#is_reference(tkn) "{{{
  return 'Reference' ==# a:tkn.label
endfunction "}}}
function! hexript#core#is_any(tkn) "{{{
  return hexript#core#is_numeric(a:tkn)
  \   || hexript#core#is_string(a:tkn)
  \   || hexript#core#is_tuple(a:tkn)
  \   || hexript#core#is_reference(a:tkn)
endfunction "}}}
function! hexript#core#check_tuple_args(self,types) "{{{
  let tuple_tkn = a:self
  let args_tkns = (a:self.matched_text)[1:]
  " PP (tuple_tkn)
  " PP (args_tkns)
  if len(a:types) > len(args_tkns)
    call hexript#exception('few arguments to tuple.', hexript#callstack())
  elseif len(a:types) < len(args_tkns)
    call hexript#exception('too many arguments to tuple.', hexript#callstack())
  else
    for idx in range(0,len(a:types)-1)
      if a:types[idx] ==# 'Any' && hexript#core#is_any(args_tkns[idx])
      elseif a:types[idx] ==# 'String' && hexript#core#is_string(args_tkns[idx])
      elseif a:types[idx] ==# 'Tuple' && hexript#core#is_tuple(args_tkns[idx])
      elseif a:types[idx] ==# 'Numeric' && hexript#core#is_numeric(args_tkns[idx])
      elseif a:types[idx] ==# 'Reference' && hexript#core#is_reference(args_tkns[idx])
      else
        call hexript#exception('invalid argument of type.', hexript#callstack())
      endif
    endfor
  endif
endfunction "}}}
" }}}

" vim: set ft=vim fdm=marker ff=unix :



scriptencoding utf-8

function! hexript#tuples#std#include#new(self) "{{{
  call hexript#core#check_tuple_args(a:self,['String'])
  let first_arg = a:self.matched_text[1]
  let filepath = eval(first_arg.matched_text)
  let tkns = hexript#core#file_to_tokens(filepath)
  return hexript#resolver#until_become_numeric_all(tkns)
endfunction "}}}

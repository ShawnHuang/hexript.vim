

scriptencoding utf-8

function! hexript#tuples#std#id#new(self) "{{{
  call hexript#core#check_tuple_args(a:self,['Any'])
  let first_arg = a:self.matched_text[1]
  return [first_arg]
endfunction "}}}

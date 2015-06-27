
io.vim
======

1. {file_path}のオブジェクト作成する。

> let f = python#io#open({file_path})

2. オブジェクトのファイルサイズを0にする。

> call f.new()

3. オブジェクトのファイルサイズを収得する。

> echo f.size()

4. オブジェクトの{address}から{bytes}分を書き込む。

> call f.write({bytes},{address})

5. オブジェクトの{address}から{length}分を読み込む。

> echo f.read({length},{address})

6. オブジェクトの{address}に{bytes}を挿入する。

> call f.insert({bytes},{address})

7. オブジェクトの末尾に{bytes}を挿入する。

> call f.append({bytes})

8. オブジェクトのサイズを{size}にする。

> call f.resize({size})

vinarise.py
===========

1.  vinarise pythonオブジェクト作成する。

> let s:obj = vinarise#python#new('objname')

2. ファイルを読み込みモードで開く。(書き込みはできない)

> call s:obj.open('./a.txt')
> ...
> call s:obj.close()

3. call s:obj.write('./b.txt')


" {{{
" let s:obj = vinarise#python#new('objname')

" './a.txt'の内容を'./b.txt'に書き込む
"
" let s:obj = vinarise#py#new('objname')
" call s:obj.open('./a.txt')
" call s:obj.write('./b.txt')
" call s:obj.close()
" let s:obj = vinarise#py#new('objname')
" call s:obj.open('./a.txt')
" echo s:obj.get_byte(0)
" 97
" echo s:obj.get_bytes(0,3)
" [97,98,99]
" call s:obj.close()

" call s:obj.open('./a.txt')
" echo s:obj.get_int8(0)
" 97
" echo s:obj.get_int16(0,1)
" 25185
" echo s:obj.get_int16(0,0)
" 24930
" echo s:obj.get_int16_le(0)
" 25185
" echo s:obj.get_int16_be(0)
" 24930
" echo s:obj.get_int32(0,1)
" 1684234849
" echo s:obj.get_int32(0,0)
" 1633837924
" echo s:obj.get_int32_le(0)
" 1684234849
" echo s:obj.get_int32_be(0)
" 1633837924
" echo s:obj.get_chars(0,1,'cp932','cp932')
" a
" echo s:obj.get_chars(0,3,'cp932','cp932')
" abc
" call s:obj.set_byte(0,0x31)
" echo s:obj.get_chars(0,1,'cp932','cp932')
" 1
" echo s:obj.get_percentage(1)
" 16
" echo s:obj.get_percentage_address(50)
" 3
" echo s:obj.find(0,'cd','cp932','cp932')
" 2
" echo s:obj.rfind(0,'cd','cp932','cp932')
" -1
" echo s:obj.rfind(6,'cd','cp932','cp932')
" 2
" echo s:obj.find_regexp(0,'[d]','cp932','cp932')
" 3
" echo s:obj.find_binary(0,"62")
" call s:obj.open_bytes("62")
" call s:obj.close()

 
" ?????
"
" call s:obj.open_bytes([1,2,3])
"
" echo s:obj.find_binary(0,0x61)
" -1
" echo s:obj.find_binary(0,0x41)
" 4
" echo s:obj.find_binary(0,char2nr('A'))
" 4
" echo s:obj.rfind_binary(0,char2nr('A'))
" echo s:obj.find_binary_not(0,char2nr('A'))
" echo s:obj.rfind_binary_not(0,char2nr('A'))
" }}}
" {{{
" let s:obj = vinarise#python#new('objname')

" './a.txt'の内容を'./b.txt'に書き込む
"
" call s:obj.open('./a.txt')
" call s:obj.close()
" let s:obj = vinarise#py#new('objname')
" call s:obj.open('./a.txt')
" echo s:obj.get_byte(0)
" 97
" echo s:obj.get_bytes(0,3)
" [97,98,99]
" call s:obj.close()

" call s:obj.open('./a.txt')
" echo s:obj.get_int8(0)
" 97
" echo s:obj.get_int16(0,1)
" 25185
" echo s:obj.get_int16(0,0)
" 24930
" echo s:obj.get_int16_le(0)
" 25185
" echo s:obj.get_int16_be(0)
" 24930
" echo s:obj.get_int32(0,1)
" 1684234849
" echo s:obj.get_int32(0,0)
" 1633837924
" echo s:obj.get_int32_le(0)
" 1684234849
" echo s:obj.get_int32_be(0)
" 1633837924
" echo s:obj.get_chars(0,1,'cp932','cp932')
" a
" echo s:obj.get_chars(0,3,'cp932','cp932')
" abc
" call s:obj.set_byte(0,0x31)
" echo s:obj.get_chars(0,1,'cp932','cp932')
" 1
" echo s:obj.get_percentage(1)
" 16
" echo s:obj.get_percentage_address(50)
" 3
" echo s:obj.find(0,'cd','cp932','cp932')
" 2
" echo s:obj.rfind(0,'cd','cp932','cp932')
" -1
" echo s:obj.rfind(6,'cd','cp932','cp932')
" 2
" echo s:obj.find_regexp(0,'[d]','cp932','cp932')
" 3
" echo s:obj.find_binary(0,"62")
" call s:obj.open_bytes("62")
" call s:obj.close()


" ?????
"
" call s:obj.open_bytes([1,2,3])
"
" echo s:obj.find_binary(0,0x61)
" -1
" echo s:obj.find_binary(0,0x41)
" 4
" echo s:obj.find_binary(0,char2nr('A'))
" 4
" echo s:obj.rfind_binary(0,char2nr('A'))
" echo s:obj.find_binary_not(0,char2nr('A'))
" echo s:obj.rfind_binary_not(0,char2nr('A'))
" }}}


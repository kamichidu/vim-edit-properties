" ----------------------------------------------------------------------------
" File:        edit-properties.vim
" Last Change: 28-Sep-2014.
" Maintainer:  kamichidu <c.kamunagi@gmail.com>
" License:     The MIT License (MIT) {{{
" 
"              Copyright (c) 2013 kamichidu
"
"              Permission is hereby granted, free of charge, to any person
"              obtaining a copy of this software and associated documentation
"              files (the "Software"), to deal in the Software without
"              restriction, including without limitation the rights to use,
"              copy, modify, merge, publish, distribute, sublicense, and/or
"              sell copies of the Software, and to permit persons to whom the
"              Software is furnished to do so, subject to the following
"              conditions:
"
"              The above copyright notice and this permission notice shall be
"              included in all copies or substantial portions of the Software.
"
"              THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"              EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
"              OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
"              NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
"              HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
"              WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
"              FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
"              OTHER DEALINGS IN THE SOFTWARE.
" }}}
" ----------------------------------------------------------------------------
if exists('g:loaded_editproperties') && g:loaded_editproperties
    finish
endif
let g:loaded_editproperties= 1

let s:save_cpo= &cpo
set cpo&vim

let g:editproperties_grepprg= get(g:, 'editproperties_grepprg', &grepprg)
let g:editproperties_grepformat= get(g:, 'editproperties_grepformat', &grepformat)

augroup vim_edit_properties
    autocmd!

    autocmd BufReadPost,FileReadPost *.properties %EditPropsDecode

    autocmd BufWritePre *.properties %EditPropsEncode
    autocmd BufWritePost *.properties %EditPropsDecode
augroup END

command! -nargs=+ -complete=file EditPropsGrep call edit_properties#grep(<f-args>)
command! -nargs=? -range EditPropsEncode call edit_properties#native2ascii(<line1>, <line2>)
command! -nargs=? -range EditPropsDecode call edit_properties#ascii2native(<line1>, <line2>)

" ctrlp.vim extension
command!
\   -nargs=1 -complete=customlist,ctrlp#edit_properties#complete
\   CtrlPEditProps call ctrlp#edit_properties#launch(<q-args>)

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim:foldenable:foldmethod=marker


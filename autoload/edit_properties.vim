" ----------------------------------------------------------------------------
" File:        autoload/edit_properties.vim
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
let s:save_cpo= &cpo
set cpo&vim

let s:V= vital#of('editproperties')
let s:L= s:V.import('Data.List')
unlet s:V

let s:n2a= edit_properties#native2ascii#get()

function! edit_properties#grep(...)
    let args= copy(a:000)

    " make pattern to searchable
    let args= map(args, 's:escapegrep(v:val)')

    " execute grep
    " save environment
    let save_env= [&grepprg, &grepformat]
    try
        " prepare
        let &grepprg= get(g:, 'editproperties_grepprg', &grepprg)
        let &grepformat= get(g:, 'editproperties_grepformat', &grepformat)

        execute 'grep' join(args, ' ')
    finally
        " restore environment
        let [&grepprg, &grepformat]= save_env
    endtry
endfunction

" \uxxxx => あ
function! edit_properties#ascii2native(lnum, ...)
    let lines= getline(a:lnum, get(a:000, 0, a:lnum))
    let buf= []

    for line in lines
        let buf+= [s:n2a.decode(line)]
    endfor

    call setline(a:lnum, buf)
endfunction

" あ => \uxxxx
function! edit_properties#native2ascii(lnum, ...)
    let lines= getline(a:lnum, get(a:000, 0, a:lnum))
    let buf= []

    for line in lines
        let buf+= [s:n2a.encode(line)]
    endfor

    call setline(a:lnum, buf)
endfunction

function! s:escapegrep(s)
    let s= s:n2a.encode(a:s)

    " only ascii
    if s ==# a:s
        return s
    endif

    if get(g:, 'editproperties_regexescape', 0)
        return substitute(s, '\c\\u', '\\\\u', 'g')
    else
        return s
    endif
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim:foldenable:foldmethod=marker

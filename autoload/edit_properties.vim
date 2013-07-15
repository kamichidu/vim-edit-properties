" ----------------------------------------------------------------------------
" File:        autoload/edit_properties.vim
" Last Change: 15-Jul-2013.
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

let s:V= vital#of('vital')
let s:L= s:V.import('Data.List')
unlet s:V

function! edit_properties#grep(...)
    let l:args= s:L.with_index(a:000)
    let l:pattern= s:find('v:val[0] =~# "^/.*/$"', l:args, ['//', -1])

    if l:pattern[1] > 0
        let l:options= a:000[0 : (l:pattern[1] - 1)]
    else
        let l:options= []
    endif

    let l:files= a:000[(l:pattern[1] + 1) : ]

    let l:pattern[0]= substitute(l:pattern[0], '^/\|/$', '', 'g')
    let l:pattern[0]= substitute(system('native2ascii', l:pattern[0]), "\n$", '', '')
    let l:pattern[0]= substitute(l:pattern[0], '\\u', '\\\\u', 'g')

    let l:save_grepprg= &l:grepprg
    let l:save_grepformat= &l:grepformat
    let &l:grepprg= g:editproperties_grepprg
    let &l:grepformat= g:editproperties_grepformat
    execute join(s:L.flatten(['grep', l:options, shellescape(l:pattern[0]), l:files]), ' ')
    let &l:grepprg= l:save_grepprg
    let &l:grepformat= l:save_grepformat
endfunction

function! s:find(predicate, list, ...)
    let l:filtered= filter(deepcopy(a:list), a:predicate)

    if empty(l:filtered)
        return a:1
    endif

    return l:filtered[0]
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim:foldenable:foldmethod=marker


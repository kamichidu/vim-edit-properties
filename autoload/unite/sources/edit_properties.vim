" ----------------------------------------------------------------------------
" File:        autoload/unite/sources/edit_properties.vim
" Last Change: 28-Dec-2013.
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

let s:V= vital#of('vim-edit-properties')
let s:L= s:V.import('Data.List')
let s:P= s:V.import('Process')
unlet s:V

let s:source= {
\   'name': 'edit_properties/locale',
\   'description': 'gathering locale different *.properties files.',
\}

function! unite#sources#edit_properties#define() " {{{
    return s:source
endfunction
" }}}

function! s:source.gather_candidates(args, context) " {{{
    if &l:filetype !=# 'jproperties'
        throw 'edit_properties: current filetype is not jproperties'
    endif

    let l:dirpath= fnamemodify(expand('%'), ':p:h')
    let l:filename= fnamemodify(expand('%'), ':t')

    let l:wildcard= s:basename(l:filename) . '*.properties'

    let l:files= globpath(l:dirpath, l:wildcard)

    return map(split(l:files, "\n"), '{"word": v:val, "kind": "file", "action__path": v:val}')
endfunction
" }}}

function! s:basename(filename) " {{{
    return substitute(a:filename, '\%(_\w\{-}\)\=\.properties$', '', '')
endfunction
" }}}

function! s:localename(filename) " {{{
    return matchstr(a:filename, '_\zs\%(\w\{-}\)\=\ze\.properties$')
endfunction
" }}}

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim:foldenable:foldmethod=marker

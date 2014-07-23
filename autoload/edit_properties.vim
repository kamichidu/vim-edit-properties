" ----------------------------------------------------------------------------
" File:        autoload/edit_properties.vim
" Last Change: 24-Jul-2014.
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

let s:n2a= edit_properties#native2ascii#get()

function! edit_properties#grep(...)
    let l:args= copy(a:000)
    " validate arguments
    if empty(filter(copy(l:args), 'v:val =~# ''^/.*/$'''))
        echoerr 'edit_properties: /pattern/ is required!'
        return
    endif
    " EditPropsGrep --hoge --fuga /aaaa/ ~/dir/filename
    " => l:grep_args == ['--hoge', '--fuga']
    " => l:pattern   == 'aaaa'
    " => l:filenames == ['~/dir/filename']
    let [l:grep_args, l:pattern, l:filenames]= [[], '', []]
    while !empty(l:args)
        let l:arg= s:L.shift(l:args)

        if l:arg =~# '^-'
            call s:L.push(l:grep_args, l:arg)
        elseif l:arg =~# '^/.*/$'
            let l:pattern= matchstr(l:arg, '^/\zs.*\ze/$')
            let l:filenames= l:args
            break
        endif

        unlet l:arg
    endwhile

    " make pattern to searchable
    let l:pattern= s:P.system('native2ascii', l:pattern)
    let l:pattern= substitute(l:pattern, "\n$", '', '')
    let l:pattern= substitute(l:pattern, '\c\\u', '\\\\u', 'g')

    " execute grep
    " save environment
    let l:save_env= [&l:grepprg, &l:grepformat]

    " prepare
    let &l:grepprg= get(g:, 'editproperties_grepprg', &l:grepprg)
    let &l:grepformat= get(g:, 'editproperties_grepformat', &l:grepformat)

    let l:cmd= join([
    \       'grep',
    \       join(l:grep_args, ' '),
    \       l:pattern,
    \       join(map(copy(l:filenames), 'expand(v:val)'), ' '),
    \   ],
    \   ' '
    \)
    execute l:cmd

    " restore environment
    let [&l:grepprg, &l:grepformat]= l:save_env
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

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim:foldenable:foldmethod=marker

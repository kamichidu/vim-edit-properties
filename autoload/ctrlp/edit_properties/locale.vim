" The MIT License (MIT)
"
" Copyright (c) 2014 kamichidu
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
if exists('g:loaded_ctrlp_editproperties_locale') && g:loaded_ctrlp_editproperties_locale
    finish
endif
let g:loaded_ctrlp_editproperties_locale= 1

let s:V= vital#of('editproperties')
let s:M= s:V.import('Vim.Message')
unlet s:V

function! ctrlp#edit_properties#locale#enter()
    let s:current_filetype= &l:filetype
    let s:current_bufname= bufname('%')
endfunction

function! ctrlp#edit_properties#locale#init()
    if s:current_filetype !=# 'jproperties'
        call s:M.warn("edit_properties: Current filetype is not `jproperties'")
        return []
    endif

    let dirpath= fnamemodify(s:current_bufname, ':p:h')
    let filename= fnamemodify(s:current_bufname, ':t')
    let basename= substitute(filename, '\%(_\w\{-}\)\=\.properties$', '', '')

    let files= globpath(dirpath, basename . '*.properties')
    call vimconsole#log(files)

    return map(split(files, "\n"), 'fnamemodify(v:val, ":.")')
endfunction

function! ctrlp#edit_properties#locale#accept(mode, str)
  call ctrlp#exit()

  if a:mode ==# 'v'
      let opener= 'split'
  elseif a:mode ==# 't'
      let opener= 'tabedit'
  elseif a:mode ==# 'h'
      let opener= 'vsplit'
  else
      let opener= 'edit'
  endif

  execute opener a:str
endfunction

let g:ctrlp_ext_vars= get(g:, 'ctrlp_ext_vars', []) + [{
\   'enter':  'ctrlp#edit_properties#locale#enter()',
\   'init':   'ctrlp#edit_properties#locale#init()',
\   'accept': 'ctrlp#edit_properties#locale#accept',
\   'lname':  'edit_properties-locale',
\   'sname':  'edit_properties-locale',
\   'type':   'path',
\}]

let s:id= g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#edit_properties#locale#id()
    return s:id
endfunction

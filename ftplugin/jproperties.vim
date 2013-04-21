" Vim filetype plugin for edit java properties files that include non-latin1 characters.
" Last Change: 21-Apr-2013.
" Maintainer:  kamichidu <c.kamunagi@gmail.com>
" License:     This file is placed in the public domain.

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin= 1

if !executable('native2ascii')
    finish
endif

let s:save_cpo= &cpo
set cpo&vim

augroup vim_edit_properties
    autocmd!

    autocmd FileType jproperties %!native2ascii -reverse

    autocmd BufWritePre *.properties %!native2ascii
    autocmd BufWritePost *.properties %!native2ascii -reverse
augroup END

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:ft=vim


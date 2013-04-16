" 
" TODO
" 
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin= 1

let s:save_cpo= &cpo
set cpo&vim

augroup vim_edit_properties
    autocmd!

    autocmd BufReadPost *.properties %!native2ascii -reverse

    autocmd BufWritePre *.properties %!native2ascii
    autocmd BufWritePost *.properties %!native2ascii -reverse
augroup END

let &cpo= s:save_cpo
" vim:ft=vim


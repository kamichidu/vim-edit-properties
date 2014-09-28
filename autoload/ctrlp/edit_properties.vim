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
let s:V= vital#of('editproperties')
let s:O= s:V.import('OptionParser')
unlet s:V

let s:opt_parser= s:O.new()

call s:opt_parser.on('--locale', "Switch current .properties file to other locale's one", {'short': '-l'})

function! ctrlp#edit_properties#launch(q_args)
    let opts= s:opt_parser.parse(a:q_args)

    if opts.locale
        call ctrlp#init(ctrlp#edit_properties#locale#id())
    endif
endfunction

function! ctrlp#edit_properties#complete(arglead, cmdline, cursorpos)
    return s:opt_parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

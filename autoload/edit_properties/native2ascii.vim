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
let s:save_cpo= &cpo
set cpo&vim

let s:native2ascii= {}

function! s:native2ascii.encode(s)
    " `s' is &encoding
    let chars= split(a:s, '\zs')
    let length= len(chars)
    let buf= []
    let i= 0

    while i < length
        let c= iconv(chars[i], &encoding, 'utf8')
        let cn= char2nr(c, 1)
        let i+= 1

        if cn > 0x003d && cn < 0x007f
            let buf+= [c]
        elseif c ==# ' '
            let buf+= [' ']
        elseif c ==# "\t"
            let buf+= ['\', 't']
        elseif c ==# "\n"
            let buf+= ['\', 'n']
        elseif c ==# "\r"
            let buf+= ['\', 'r']
        elseif c ==# "\f"
            let buf+= ['\', 'f']
        else
            if cn < 0x0020 || cn > 0x007e
                let buf+= ['\', 'u', printf('%04x', cn)]
            else
                let buf+= [c]
            endif
        endif
    endwhile

    return iconv(join(buf, ''), 'utf8', &encoding)
endfunction

function! s:native2ascii.decode(s)
    let chars= split(a:s, '\zs')
    let length= len(chars)
    let buf= []
    let i= 0

    while i < length
        let c= chars[i]
        let i+= 1

        if c ==# '\' && i < length
            let c= chars[i]
            let i+= 1

            if c ==# 'u'
                " read the xxxx
                let buf+= s:nr2char(eval('0x' . join(chars[i : (i + 3)], '')))
                let i+= 4
            else
                let buf+= ['\', c]
            endif
        else
            let buf+= [c]
        endif
    endwhile

    return join(buf, '')
endfunction

function! s:nr2char(nr)
    let c= iconv(nr2char(a:nr, 1), 'utf8', &encoding)

    if c !=# '?'
        return [c]
    else
        return ['\', 'u'] + split(printf('%04x', a:nr), '\zs')
    endif
endfunction

function! edit_properties#native2ascii#get()
    return deepcopy(s:native2ascii)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo

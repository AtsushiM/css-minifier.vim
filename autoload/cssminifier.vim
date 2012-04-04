"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/html-minifier.vim
"VERSION:  0.9
"LICENSE:  MIT

function! cssminifier#CommentRemove()
    let line = getline('.')
    let end = 0
    let ret = ''

    while end == 0
        let i = matchlist(line, '\v(.{-})(/\*.{-}\*/)(.*)')

        if i != []
            let ret = ret.i[1]
            let line = i[3]
        else
            let ret = ret.line
            let end = 1
        endif
    endwhile
    call setline('.', ret)
endfunction

function! cssminifier#removeExstraSpace(line, needle)
    let end = 0
    let min = ''
    let ret = a:line
    let nee = a:needle

    while end == 0
        let i = matchlist(ret, '\v(.{-})\s*('.nee.')\s*(.*)')

        if i != []
            let min = min.i[1].i[2]
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    return min
endfunction

function! cssminifier#Exe(...)
    " remove return & indent
    let html = readfile(expand('%'))
    let ret = ''
    for e in html
        let i = matchlist(e, '\v^(\s*)(.*)')
        if i != []
            let ret = ret.i[2]
        endif
    endfor

    " remove comment
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-})/\*.{-}\*/(.*)')
        if i != []
            let min = min.i[1]
            let ret = i[2]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    " remove space
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-})(\s+)(.*)')

        if i != []
            let min = min.i[1].' '
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    " remove extra space
    let ret = cssminifier#removeExstraSpace(ret, '\{')
    let ret = cssminifier#removeExstraSpace(ret, '\}')
    let ret = cssminifier#removeExstraSpace(ret, '\(')
    let ret = cssminifier#removeExstraSpace(ret, '\)')
    let ret = cssminifier#removeExstraSpace(ret, '\"')
    let ret = cssminifier#removeExstraSpace(ret, '\,')
    let ret = cssminifier#removeExstraSpace(ret, ':')
    let ret = cssminifier#removeExstraSpace(ret, ';')

    " remove extra semicolon
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-});(\})(.*)')

        if i != []
            let min = min.i[1].i[2]
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    if a:0 != 0
        let fname = a:000[0]
    else
        let fname = expand('%:p:r').'.min.'.expand('%:e')
    endif
    call writefile([ret], fname)
endfunctio

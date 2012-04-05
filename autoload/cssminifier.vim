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
    let output = ''
    let input = ''

    if a:0 != 0
        for e in a:000
            let eary = split(e,'=')
            if eary[0] == '-input'
                let input = eary[1]
            elseif eary[0] == '-output'
                let output = eary[1]
            endif
        endfor
    endif

    if input == ''
        let input = expand('%')
    endif
    if output == ''
        let output = fnamemodify(input, ':p:r').'.min.'.fnamemodify(input, ':e')
    endif

    " remove return & indent
    let css = readfile(input)
    let ret = ''
    for e in css
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

    call writefile([ret], output)
endfunctio

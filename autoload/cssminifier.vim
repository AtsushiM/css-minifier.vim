"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/html-minifier.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

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

function! cssminifier#Exe(...)
    let output = ''
    let input = ''
    let start = 0
    let end = 0

    if a:0 != 0
        for e in a:000
            let eary = split(e,'=')
            if eary[0] == '-input'
                let input = eary[1]
            elseif eary[0] == '-output'
                let output = eary[1]
            elseif eary[0] == '-start'
                let start = eary[1] - 1
            elseif eary[0] == '-end'
                let end = eary[1] - 1
            endif
        endfor
    endif

    if input == ''
        let input = expand('%')
    endif
    if output == ''
        let output = fnamemodify(input, ':p:r').'.min.'.fnamemodify(input, ':e')
    endif

    let css = readfile(input)

    if end == 0
        let end = len(css)
    endif

    let ary_before = []
    let ary_after = []
    let ret = ''
    let pointer = 0
    for e in css
        if pointer >= start && pointer <= end
            let i = matchlist(e, '\v^(\s*)(.*)')
            if i != []
                let ret = ret.i[2]
            endif
        else
            if pointer < start
                call add(ary_before, e)
            else
                call add(ary_after, e)
            endif
        endif
        let pointer = pointer + 1
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
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-})\s*([\{\}\(\)\"\,:;])\s*(.*)')

        if i != []
            let min = min.i[1].i[2]
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

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

    " remove dabule quotes
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-}url\()"(.{-})"(\).*)')

        if i != []
            let min = min.i[1].i[2]
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    " remove single quotes
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-}url\()''(.{-})''(\).*)')

        if i != []
            let min = min.i[1].i[2]
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    " remove 0.x
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-} )0(\.[0-9]+.*)')

        if i != []
            let min = min.i[1]
            let ret = i[2]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    call add(ary_before, ret)
    call extend(ary_before, ary_after)

    let outdir = fnamemodify(output, ':h')
    if !isdirectory(outdir)
        call mkdir(outdir, 'p')
    endif
    call writefile(ary_before, output, 'b')
endfunctio

let &cpo = s:save_cpo

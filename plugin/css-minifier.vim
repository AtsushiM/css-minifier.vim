"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/html-minifier.vim
"VERSION:  0.9
"LICENSE:  MIT

if exists("g:loaded_css_minifier")
    finish
endif
let g:loaded_css_minifier = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* CSSMinifier call cssminifier#Exe(<f-args>)
command! -range CSSCommentRemove <line1>,<line2>call cssminifier#CommentRemove()

let &cpo = s:save_cpo

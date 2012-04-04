"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/html-minifier.vim
"VERSION:  0.9
"LICENSE:  MIT

command! -nargs=? CSSMinifier call cssminifier#Exe(<f-args>)
command! -range CSSCommentRemove <line1>,<line2>call cssminifier#CommentRemove()

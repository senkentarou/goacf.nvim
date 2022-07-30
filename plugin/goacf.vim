scriptencoding utf-8

if exists('g:loaded_to_goacf')
    finish
endif
let g:loaded_to_goacf = 1

let s:save_cpo = &cpo
set cpo&vim

command! Goacf lua require('goacf').goacf()

let &cpo = s:save_cpo
unlet s:save_cpo

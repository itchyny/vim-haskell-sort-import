" =============================================================================
" Filename: plugin/haskell_sort_import.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/12/21 07:29:10.
" =============================================================================

if exists('g:loaded_haskell_sort_import') || v:version < 700
  finish
endif
let g:loaded_haskell_sort_import = 1

let s:save_cpo = &cpo
set cpo&vim

command! HaskellSortImport call haskell_sort_import#sort()

let &cpo = s:save_cpo
unlet s:save_cpo

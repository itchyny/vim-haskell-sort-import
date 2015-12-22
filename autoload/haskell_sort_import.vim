" =============================================================================
" Filename: autoload/haskell_sort_import.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/12/21 07:51:25.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:sorter(x, y) abort
  return (matchstr(a:x, 'import *\%(qualified\)\? *\zs\S\+') > matchstr(a:y, 'import *\%(qualified\)\? *\zs\S\+')) * 2 - 1
endfunction

function! haskell_sort_import#sort() abort
  let start = 0
  let end = 0
  for i in range(1, line('$'))
    if getline(i) =~# '^\s*\<import\>'
      if start == 0
        let start = i
      endif
    elseif start > 0
      let end = i
      break
    endif
  endfor
  if start > 0 && end == 0
    let end = line('$')
  endif
  if start > 0 && end > start
    let lines = map(range(start, end), 'getline(v:val)')
    if join(lines) !=# join(sort(lines, function('s:sorter')))
      call setline(start, sort(lines, function('s:sorter')))
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

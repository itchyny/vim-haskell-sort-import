" =============================================================================
" Filename: autoload/haskell_sort_import.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/12/25 08:54:36.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! haskell_sort_import#sort() abort
  let start = 0
  let end = 0
  for i in range(1, line('$'))
    if getline(i) =~# '^\s*\<import\>'
      if start == 0
        let start = i
      endif
    endif
    if getline(i) !~# '^\s*\<import\>' && start > 0
      call s:sort(start, i - 1)
      let start = 0
    elseif i == line('$') && start > 0
      call s:sort(start, i)
      let start = 0
    endif
  endfor
endfunction

function! s:sorter(x, y) abort
  return (matchstr(a:x, 'import *\%(qualified\)\? *\zs\S\+') > matchstr(a:y, 'import *\%(qualified\)\? *\zs\S\+')) * 2 - 1
endfunction

function! s:sort(start, end) abort
  if a:start > 0 && a:end > a:start
    let lines = map(range(a:start, a:end), 'getline(v:val)')
    if join(lines) !=# join(sort(lines, function('s:sorter')))
      call setline(a:start, sort(lines, function('s:sorter')))
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

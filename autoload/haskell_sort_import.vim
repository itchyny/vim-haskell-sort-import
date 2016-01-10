" =============================================================================
" Filename: autoload/haskell_sort_import.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/01/10 09:29:15.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! haskell_sort_import#sort() abort
  let start = 0
  let continuing = 0
  let lines = []
  let import = []
  for i in range(1, line('$'))
    let line = getline(i)
    if line =~# '^\s*\<import\>'
      if len(import) > 0
        call add(lines, import)
      endif
      let import = [line]
      let continuing = line =~# '\v^\s*import\s+(qualified\s+)?[[:alnum:].]+\s*\(([^()]|\([^()]+\))*$'
      if start == 0
        let start = i
      endif
    elseif continuing
      call add(import, line)
      let continuing = line !~# '\v^([^()]|\([^()]+\))*\)(\s*--.*)?$'
    elseif start > 0
      call add(lines, import)
      call s:sort(start, lines)
      let start = 0
      let continuing = 0
      let lines = []
      let import = []
    endif
  endfor
  if start > 0
    call add(lines, import)
    call s:sort(start, lines)
  endif
endfunction

function! s:sorter(x, y) abort
  let pattern = '\v^import\s+(qualified\s+)?\zs[[:alnum:].]+'
  return (matchstr(a:x[0], pattern) > matchstr(a:y[0], pattern)) ? 1 : -1
endfunction

function! s:sort(start, lines) abort
  if a:start > 0 && len(a:lines) > 1
    if join(a:lines) !=# join(sort(a:lines, function('s:sorter')))
      call setline(a:start, s:concat(sort(a:lines, function('s:sorter'))))
    endif
  endif
endfunction

function! s:concat(xs) abort
  let ret = []
  for x in a:xs
    let ret += x
  endfor
  return ret
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

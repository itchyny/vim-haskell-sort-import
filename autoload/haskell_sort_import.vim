" =============================================================================
" Filename: autoload/haskell_sort_import.vim
" Author: itchyny
" License: MIT License
" Last Change: 2025/04/11 23:21:50.
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
      let continuing = line =~# '\v^\s*import\s+%(qualified\s+)?' .
            \ '[[:alnum:].]+\s*\(%([^()]|\(%([^()]|\([^()]+\))+\))*%(\s*--.*)?$'
      if start == 0
        let start = i
      endif
    elseif continuing
      call add(import, line)
      let continuing = line !~# '\v^\s*%([^()]|\(%([^()]|\([^()]+\))+\))*\)%(\s*--.*)?$'
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
  let pattern = '\v^import\s+(qualified\s+)?\zs[[:alnum:].]+(\s+\a+)?'
  let xs = matchstr(a:x[0], pattern)
  let ys = matchstr(a:y[0], pattern)
  return xs =~# '^Prelude\>' ? 1 :
        \ ys =~# '^Prelude\>' ? -1 :
        \ xs ># ys ? 1 : xs <# ys ? -1 : 0
endfunction

function! s:sort(start, lines) abort
  if a:start > 0 && len(a:lines) > 1
    let sorted = sort(map(deepcopy(a:lines), 'map(v:val, "s:sort_line(v:val)")'), function('s:sorter'))
    if a:lines !=# sorted
      call setline(a:start, s:concat(sorted))
    endif
  endif
endfunction

function! s:sort_line(line) abort
  let x = '%([[:alnum:]_'."'".']+%(\(%([^()]|\([^()]+\))+\))?|\([^()]+\))'
  let xs = matchlist(a:line, '\v^(import\s+%(qualified\s+)?[[:alnum:].]+' .
        \ '%(\s+as\s+\w+)?%(\s+hiding)?\s*\(\s*)' .
        \ '(%(' . x . '\s*,\s*)*' . x . ')(\s*\)%(\s*--.*)?)$')
  return xs == [] ? a:line : xs[1] . join(sort(split(
        \ substitute(xs[2], '\v%(^\s+|\s+$)', '', 'g'), '\s*,\s*'),
        \ function('s:line_sorter')), ', ') . xs[3]
endfunction

function! s:line_sorter(x, y) abort
  return a:x =~# '^(' && a:y !~# '^(' ? 1 :
        \ a:x !~# '^(' && a:y =~# '^(' ? -1 :
        \ a:x ># a:y ? 1 : a:x <# a:y ? -1 : 0
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

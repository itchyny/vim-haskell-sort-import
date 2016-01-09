let s:assert = themis#helper('assert')

function! s:before()
  filetype plugin indent on
  setlocal filetype=haskell
endfunction

function! s:before_each()
  % delete _
endfunction

function! s:test(path)
  for path in filter(split(glob(a:path . '/*')), 'isdirectory(v:val)')
    let suite = themis#suite('Test for ' . matchstr(path, '\w*$'))
    let suite.before = function('s:before')
    let suite.before_each = function('s:before_each')
    for infile in split(glob(path . '/*.in.hs', 1), "\n")
      execute join([
            \ 'function! suite.' . matchstr(infile, '\w*\ze\.in\.hs$') . '()'
            \,'  let infile = ' . string(infile)
            \,'  let outfile = ' . string(substitute(infile, '\.\zsin\ze\.hs$', 'out', ''))
            \,'  execute "read" infile'
            \,'  1 delete _'
            \,'  HaskellSortImport'
            \,'  call s:assert.equals(getline(1, line("$")), readfile(outfile))'
            \,'endfunction' ], "\n")
    endfor
  endfor
endfunction

call s:test(expand('<sfile>:p:h'))

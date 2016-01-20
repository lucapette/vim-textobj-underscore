if exists('g:loaded_textobj_underscore')
  finish
endif

call textobj#user#plugin('underscore', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'a_',  '*select-a-function*': 's:select_a',
\        'select-i': 'i_',  '*select-i-function*': 's:select_i'
\      }
\    })

" Start Pos:
" 1. "_" ("foo[_]bar[_]baz")
" word character after
" 2. [:space:] ("  [f]oo_bar_baz")
" 3. ^ ("[f]oo_bar_baz")
" 4. \W (":[s]mile:")
"
" End Pos:
" 1. "_" ("foo[_]bar[_]baz")
" word character before
" 2. [:space:] ("foo_bar_ba[z]  ")
" 3. $ ("foo_bar_ba[z]")
" 4. \W (":smil[e]:")
function! s:select_a()
  let pattern = '\%' . line('.') . 'l\%(_\|\%([[:space:]]\|^\|\W\)\zs\w\)'
  call search(pattern, 'bcW')
  let start_pos = getpos('.')

  let pattern = '\%' . line('.') . 'l\%(_\|\w\ze\%([[:space:]]\|$\|\W\)\)'
  call search(pattern, 'W')
  let end_pos = getpos('.')

  return (start_pos ==# end_pos ? 0 : ['v', start_pos, end_pos])
endfunction

" Start Pos:
" word character after
" 1. "_" ("foo_[b]ar_[b]az")
" 2. [:space:] ("  [f]oo_bar_baz")
" 3. ^ ("[f]oo_bar_baz")
" 4. \W (":[s]mile:")
"
" End Pos:
" word character before
" 1. "_" ("fo[o]_ba[r]_baz")
" 2. [:space:] ("foo_bar_ba[z]  ")
" 3. $ ("foo_bar_ba[z]")
" 4. \W (":smil[e]:")
function! s:select_i()
  let pattern = '\%' . line('.') . 'l\%([_[:space:]]\|^\|\W\)\zs\w'
  call search(pattern, 'bcW')
  let start_pos = getpos('.')

  let pattern = '\%' . line('.') . 'l\w\ze\%([_[:space:]]\|$\|\W\)'
  call search(pattern, 'cW')
  let end_pos = getpos('.')

  return (start_pos ==# end_pos ? 0 : ['v', start_pos, end_pos])
endfunction

let g:loaded_textobj_underscore = 1

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

function! s:select_a()
  let end_pos = s:search(s:is_backward, s:is_a)
  let start_pos = s:search(s:is_forward, s:is_a)

  return ['v', start_pos, end_pos]
endfunction

" ciao_come_stai

function! s:select_i()
  let end_pos = s:search(s:is_backward, s:is_inner)
  let start_pos = s:search(s:is_forward, s:is_inner)

  return ['v', start_pos, end_pos]
endfunction

let s:is_forward = 1
let s:is_backward = 0
let s:is_inner  = 1
let s:is_a = 0


function! s:get_current_cursor_char()

	let org = @a

	normal! "ayl
	let result = @a

	let @a = org

	return result

endfunction


function! s:search(is_forward, is_inner)

	let org_pos = getpos('.')

	" Do nothing if the cursor is on underscore.
	if s:get_current_cursor_char() == '_'
		return org_pos
	endif

	if a:is_inner != 0
		" inner underscore(i_).

		if a:is_forward != 0
			call search('\v\zs.($|_|\W)', 'cW')
		else
			call search('\v(^|_|\W)\zs[0-9a-zA-Z]', 'bcW')
		endif

	else
		" a underscore(a_).

		if a:is_forward != 0
			call search('\v$|_|\W', 'cW')

			" Narrow down the range if the cursor is on \W,
			if s:get_current_cursor_char() !~? '\v\w|\s'
				normal! ge
			endif

		else
			call search('\v^|_|\W', 'bcW')

			" Narrow down the range if the cursor is on \W,
			if s:get_current_cursor_char() !~? '\v\w|\s'
				normal! w
			endif

		endif
	endif

	let result = getpos('.')

	" Return the cursor to original position.
	call setpos('.', org_pos)

	return result

endfunction


let g:loaded_textobj_underscore = 1



"##########################################################
" Initialize some stuff
scriptencoding utf-8
if exists('g:loaded_startscreen') | finish | endif
let g:loaded_startscreen = 1
let s:save_cpo = &cpo
set cpo&vim


"##########################################################
" Options

fun! startscreen#open_file()
    let l:file_path = '~/AppData/Local/nvim/Dashboard.txt'
    execute 'edit ' . l:file_path

    " Calculate the number of lines in the buffer
    let l:num_lines = line('$') - line('1') + 1

    " Calculate the middle of the buffer
    let l:middle_line = l:num_lines / 2

    " Scroll to the middle of the buffer
    execute 'normal! ' . l:middle_line . 'H'
endfun

if !exists('g:Startscreen_function')
    let g:Startscreen_function = function('startscreen#open_file')
endif


" Set a fancy start screen
fun! startscreen#start()
	" Don't run if:
	" - there are commandline arguments;
	" - the buffer isn't empty (e.g. cmd | vi -);
	" - we're not invoked as vim or gvim;
	" - we're starting in insert mode.
	if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
		return
	endif

	" Start a new buffer...
	enew

	" ...and set some options for it
	setlocal
		\ bufhidden=wipe
		\ buftype=nofile
		\ nobuflisted
		\ nocursorcolumn
		\ nocursorline
		\ nolist
		\ nonumber
		\ noswapfile
		\ norelativenumber

	" Now we can just write to the buffer whatever you want.
	call g:Startscreen_function()

	" No modifications to this buffer
	setlocal nomodifiable nomodified

	" When we go to insert mode start a new buffer, and start insert
	nnoremap <buffer><silent> e :enew<CR>
	nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
	nnoremap <buffer><silent> o :enew <bar> startinsert<CR><CR>
	nnoremap <buffer><silent> p :enew<CR>p
	nnoremap <buffer><silent> P :enew<CR>P
	" TODO: Map more keys. e.g. I often start Vim to paste something from the OS
	" clipboard (<Leader>p), but I have to clear this startscreen first :-/
endfun


"##########################################################
" Auto command
augroup startscreen
    autocmd!
    autocmd VimEnter * call startscreen#start()
augroup end


let &cpo = s:save_cpo
unlet s:save_cpo



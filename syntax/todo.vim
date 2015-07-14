" Vim syntax file
" Language:        todo
" Maintainer:      Peter Lundgren <peter@peterlundgren.com>
" URL:             https://github.com/peterlundgren/vim-todo
" Filenames:       TODO, *.todo
" Latest Revision: 2015 July 12

if exists("b:current_syntax")
  finish
endif

if has("folding")
  setlocal foldmethod=syntax
endif

syn sync fromstart

function! s:CreateTaskBlock(indentLevel)
  let l:indent = repeat("    ", a:indentLevel)
  exe "syn region taskBlock" . a:indentLevel . " start=/^" . l:indent .
      \ "\\[[ .x]\\] / end=/^ \\{0," . (a:indentLevel * 4) .
      \ "}\\[[ .x]\\] /me=s-1,he=s-1,re=s-1 fold contains=newTask" .
      \ a:indentLevel . ",inProgressTask" . a:indentLevel . ",completedTask" .
      \ a:indentLevel . ",taskBlock" . (a:indentLevel + 1) . ",url"
endfunction

function! s:HighlightTask(indentLevel)
  let l:indent = repeat("    ", a:indentLevel)
  let l:bold = a:indentLevel ? "" : " gui=bold"

  exe "syn match newTask" . a:indentLevel . " '^" . l:indent . "\\[ \\] .*$' contained"
  exe "syn match inProgressTask" . a:indentLevel . " '^" . l:indent . "\\[\\.\\] .*$' contained"
  exe "syn match completedTask" . a:indentLevel . " '^" . l:indent . "\\[x\\] .*$' contained"

  exe "hi newTask" . a:indentLevel . " ctermfg=DarkBlue guifg=#268bd2" . l:bold
  exe "hi inProgressTask" . a:indentLevel . " ctermfg=DarkYellow guifg=#b58900" . l:bold
  exe "hi completedTask" . a:indentLevel . " ctermfg=DarkCyan guifg=#2aa198" . l:bold
endfunction

for i in [0, 1, 2, 3, 4]
  call s:CreateTaskBlock(i)
  call s:HighlightTask(i)
endfor

syn match url "http:[^\s]\+" contained
hi link url Comment

function! TodoFoldText()
    let line = getline(v:foldstart)
    return line . " (" . (v:foldend - v:foldstart + 1) . " lines)"
endfunction

set foldtext=TodoFoldText()

let b:current_syntax = "todo"

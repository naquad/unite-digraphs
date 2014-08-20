let s:save_cpo = &cpo
set cpo&vim

function! s:make_candidate(line)
  let cols = split(substitute(a:line[1:], '^.\S*\s*', '', ''), '\s\+')
  let code = str2nr(cols[2])

  return {
        \ 'word': a:line,
        \ 'action__text': nr2char(code, code > 255)
        \ }
endfunction

let s:base_dir = expand('<sfile>:p:h')
let s:digraphs = readfile(s:base_dir . '/digraphs.txt')

if has('multi_byte')
  call extend(s:digraphs, readfile(s:base_dir . '/digraphs-multibyte.txt'))
endif

call map(s:digraphs, 's:make_candidate(v:val)')

let s:source = {
      \ 'name' : 'digraphs',
      \ 'description' : 'provides digraphs list',
      \ 'default_kind' : 'word',
      \ }

function! s:source.gather_candidates(args, context)
  return s:digraphs
endfunction

function! unite#sources#digraphs#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

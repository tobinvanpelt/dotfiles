" Compiler file for nose

if exists("current_compiler")
  finish
endif
let current_compiler = "nose"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet efm=%f:%l:\ fail:\ %m,%f:%l:\ error:\ %m
CompilerSet shellpipe=--err-file=%s

let s:nose_splitter = expand('<sfile>:h') . '/../python/nose_splitter.py'
let &l:makeprg='python ' . s:nose_splitter . ' $* --with-results-splitter'

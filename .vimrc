set nocompatible 

call plug#begin('~/.vim/bundle')
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
call plug#end()

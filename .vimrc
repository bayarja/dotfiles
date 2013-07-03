" Environment

" Basic
set nocompatible        " Must be first line
if !(has('win16') || has('win32') || has('win64'))
  set shell=/bin/sh
endif

" Windows Compatible
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Setup Bundle Support
filetype on
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Use local bundles if available
if filereadable(expand("~/.vimrc.bundles.local"))
  source ~/.vimrc.bundles.local
endif

" Use bundles config
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" General setting
set background=dark         " Assume a dark background
if !has('gui')
  "set term=$TERM          " Make arrow and other keys work
endif
filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
set encoding=utf-8
set nobackup                                 " Disabling backup since files are in git
set noswapfile                               " Disabling swapfile
set nowb


if has ('x') && has ('gui') " On Linux use + register for copy-paste
  set clipboard=unnamedplus
elseif has ('gui')          " On mac and Windows, use * register for copy-paste
  set clipboard=unnamed
endif

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set nospell                         " disable spell checking
set history=1000                    " Store a ton of history (default is 20)
set hidden                          " Allow buffer switching without saving

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Vim UI
colorscheme jellybeans
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set cursorline                  " Highlight current line
highlight clear SignColumn      " SignColumn should match background for
" things like vim-gitgutter

if has('cmdline_info')
  set ruler                   " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd                 " Show partial commands in status line and
  " Selected characters/lines in visual mode
endif

if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code set list
set listchars=tab:›\ ,trail:•,extends:>,nbsp:.,precedes:< " Highlight problematic whitespace

set nowrap                      " Wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 2 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

autocmd FileType ruby,c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" Key binding
let mapleader = ','
nnoremap <CR> :nohlsearch<cr>
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

if has("user_commands")
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif

cmap Tabe tabe

map <S-H> gT
map <S-L> gt

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Easier horizontal scrolling
map zl zL
map zh zH

" Plugins
" PIV
let g:DisableAutoPHPFolding = 0
let g:PIVAutoClose = 0

" Misc
let g:NERDShutUp=1
let b:match_ignorecase = 1

" OmniComplete
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif

hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

" Some convenient mappings
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest

" Ctags
set tags=./tags;/,~/.vimtags

" AutoCloseTag
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings

" NerdTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" Tabularize
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" Sessionman
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>

" ctrlP "
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" On Windows use "dir" as fallback command.
if has('win32') || has('win64')
  let g:ctrlp_user_command = {
        \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': 'dir %s /-n /b /s /a-d'
        \ }
else
  let g:ctrlp_user_command = {
        \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': 'find %s -type f'
        \ }
endif

" Figutive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
nnoremap <silent> <leader>gg :GitGutterToggle<CR>

" neocomplcache
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_max_list = 15
let g:neocomplcache_force_overwrite_completefunc = 1

" SuperTab like snippets behavior.
imap <silent><expr><TAB> neosnippet#expandable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
      \ "\<C-e>" : "\<TAB>")
smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns._ = '\h\w*'

" Plugin key-mappings.

" These two lines conflict with the default digraph mapping of <C-K>
" If you prefer that functionality, add
" let g:spf13_no_neosnippet_expand = 1
" in your .vimrc.bundles.local file

if !exists('g:spf13_no_neosnippet_expand')
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
endif

inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <expr><CR> neocomplcache#complete_common_string()

" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" <CR>: close popup
" <s-CR>: close popup and save indent.
inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" Use honza's snippets.
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" Enable neosnippet snipmate compatibility mode
let g:neosnippet#enable_snipmate_compatibility = 1

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
set completeopt-=preview

" ----------------------------------------
" Gundo history
" ----------------------------------------
let g:gundo_right = 1
let g:gundo_preview_bottom = 1

" Snipmate
let g:snips_author = 'Orgil <orgil.u@gmail.com>'

" GUI Setting
if has('gui_running')
  set guioptions-=T           " Remove the toolbar
  set lines=40                " 40 lines of text instead of 24
  if has("gui_gtk2")
    set guifont=Ubuntu\ Mono:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
  elseif has("gui_mac")
    set guifont=Inconsolata-dz\ for\ Powerline:h16 " setting font and size
  elseif has("gui_win32")
    set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
  endif
  if has('gui_macvim')
    set guifont=Inconsolata\ for\ Powerline:h16 " setting font and size
    set transparency=2      " Make the window slightly transparent
  endif
else
  if &term == 'xterm' || &term == 'screen'
    set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
  endif
  "set term=builtin_ansi       " Make arrow and other keys work
endif

" Functions
function! StripTrailingWhitespace()
  " To disable the stripping of whitespace, add the following to your
  " .vimrc.local file:
  "   let g:spf13_keep_trailing_whitespace = 1
  if !exists('g:spf13_keep_trailing_whitespace')
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endif
endfunction

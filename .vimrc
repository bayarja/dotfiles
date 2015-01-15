" ======================== Required configs ==============================
set nocompatible              " be iMproved, required
" on windows, setting runtime path to .vim same as *nix system
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Vundle
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
call vundle#end()            " required

filetype plugin indent on    " required

if !has('gui_running') && has('win32')
  set term=xterm
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
else
  set t_Co=256
endif

" ======================== Global configs ==============================
set mouse=a
set mousehide
setglobal fileencoding=utf-8
set encoding=utf-8
scriptencoding utf-8

set nobackup                                 " Disabling backup since files are in git
set noswapfile                               " Disabling swapfile
set nowb
set clipboard+=unnamed
set timeoutlen=1000 ttimeoutlen=0
set laststatus=2

syntax on

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set nospell                         " disable spell checking
set history=1000                    " Store a ton of history (default is 20)
set hidden                          " Allow buffer switching without saving

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                      " Showing line numbers
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=3                " Lines to scroll when cursor leaves screen
set scrolloff=5                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code set list
set listchars=tab:›\ ,trail:.,extends:>,nbsp:.,precedes:< " Highlight problematic whitespace
set splitright

set nowrap                      " No Wrap long lines
set synmaxcol=512
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 2 spaces
set expandtab                   " Tabs are spaces, not tabs

set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
"set matchpairs+=<:>             " Match, to be used with %
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
set colorcolumn=120             " Since we mostly use widescreen monitor so we monitor it should be longer than 80
set textwidth=0

set novisualbell                             " Disabling bell sound
set noerrorbells                             " Disabling bell sound
set autoread

set tabpagemax=15               " Only show 15 tabs
set noshowmode                  " Hiding current mode under statusline
set cursorline                  " Highlight current line
highlight clear SignColumn      " SignColumn should match background for
                                " things like vim-gitgutter

set background=dark
colorscheme hybrid
" ======================== GUI configs ==============================

" Setting font for GUI otherwise it sets terminal font
if has('gui_running')
  set guioptions-=T           " Remove the toolbar
  set lines=80
  if has("gui_gtk2")
    set guifont=Ubuntu\ Mono:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
  elseif has("gui_win32")
    " fullscreen on gvim
    au GUIEnter * simalt ~x
    set guifont=Powerline\ Consolas:h11
  elseif has('gui_macvim')
    set guifont=Inconsolata-dz\ for\ Powerline:h12 " setting font and size
    set transparency=2      " Make the window slightly transparent
  endif
  "set term=builtin_ansi       " Make arrow and other keys work
endif
                                
" ======================== Filetype & Autocmd ==============================

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" on windows, set cl compiler
if has('win32') || has('win64')
  au BufEnter *.c,*.cpp compiler cl 
endif

" setting auto commands
autocmd FileType ruby,c,cpp,java,go,php,javascript,python,twig,xml,yml,stylus,sass autocmd BufWritePre <buffer> call StripTrailingWhitespace()

autocmd BufNewFile,BufRead *.c,*.h set filetype=c
autocmd BufNewFile,BufRead *.cpp set filetype=cpp
autocmd BufNewFile,BufRead *.php set filetype=php
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest

" OmniComplete
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType phtml,html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#CompleteRuby

" =========================== Custom Global Keybindings ===============================
let mapleader = ','

" Setting clipboard copy functionality
if has('gui_macvim')
  noremap <leader>y "*y
  noremap <leader>yy "*Y
else
  noremap <leader>y "+y
  noremap <leader>yy "+Y
endif

" Preserve indentation while pasting text from the clipboard
noremap <leader>p :set paste<CR>:put  +<CR>:set nopaste<CR>

if has('win32') || has('win64')
  "mapping Alt+m to run Make
  nnoremap í :Make<CR>
endif

" no highlight after press enter
nnoremap <CR> :nohlsearch<cr>

" switch between last buffer
nnoremap <leader><leader> <c-^>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" navigating through tab
map <S-H> gT
map <S-L> gt

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Move to the next tab
nmap gl gT
" Move to the previous tab
nmap gh gt
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove"
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/


" running rspec
nnoremap <leader>rs :!clear;rspec --color spec<cr>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Easier horizontal scrolling
map zl zL
map zh zH

" Folding keymap
nnoremap <space> za
vnoremap <space> zf

" Splitting lines
nnoremap K i<CR><Esc>

" show pending tasks list
map <F2> :TaskList<CR>


" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" Disabling arrow key motions
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" =========================== Plugin configs & Keybindings ===============================

" YouCompleteMe

"Airline
let g:airline_powerline_fonts  = 1
let g:airline_theme            = 'powerlineish'
let g:airline#extensions#hunks#enabled = 0

" only showing filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'

" PIV
let g:DisableAutoPHPFolding = 1
let g:PIVAutoClose = 0

" Misc
let b:match_ignorecase = 1


" Indent guide color
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

" hi PmenuSel  guifg=#b5e3ff guibg=#424242 ctermfg=Blue ctermbg=238
" hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=Lightgray cterm=NONE
" hi PmenuThumb  guifg=#FFFFFF guibg=#555555 gui=NONE ctermfg=darkcyan ctermbg=Lightgray cterm=NONE

" NerdTree
if has('win32') || has('win64')
  let g:NERDTreeCopyCmd= 'cp -r'
endif
let g:NERDTreeDirArrows = 1
let NERDTreeIgnore=['\.sass-cache$[[dir]]','\.pyc', '\~$', '\.swo$', '\.swp$', '\.git[[dir]]', '\.hg', '\.svn', '\.bzr', '\.scssc', '\.sassc', '^\.$', '^\.\.$', '^Thumbs\.db$']
let NERDTreeMouseMode=0
let NERDTreeShowHidden=1
let NERDTreeChDirMode=1

" Increase tree width slightly
let NERDTreeWinSize = 38
" Change working directory to the root automatically

nmap <F4> :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeFind<CR>

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

let g:ctrlp_map=''
nnoremap <silent> <C-p> :CtrlP<CR>
nnoremap <silent> <C-t> :CtrlPTag<CR>
nnoremap <silent> <C-f> :CtrlPFunky<CR>
nnoremap <silent> <C-b> :CtrlPBuffer<CR>

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn|sassc)$',
      \ 'file': '\v\.(exe|so|dll|png|jpg|gif|jpeg|swf|pdf|mp3)$'
      \}
let g:ctrlp_extensions = ['funky']

" Figutive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
nnoremap <silent> <leader>gg :GitGutterToggle<CR>

nnoremap <silent> <leader>ss :SaveSession<CR>
nnoremap <silent> <leader>sd :DeleteSession<CR>

" UltiSnip
let g:UltiSnipsUsePythonVersion = 2

" neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15
let g:neocomplete#force_overwrite_completefunc = 1

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

let g:session_autosave = 'no'
let g:session_autoload = 'yes'

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.coffee = '\S*\|\S*::\S*?'
let g:neocomplete#sources#omni#input_patterns.javascript = '[^. *\t]\w*\|[^. *\t]\.\%(\h\w*\)\?'

" Use honza's snippets.
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" Enable neosnippet snipmate compatibility mode
let g:neosnippet#enable_snipmate_compatibility = 1

" Indent guides
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
" set completeopt-=preview

" Gundo history tree
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
nnoremap <F6> :GundoToggle<CR>

" Numbers
nnoremap <F3> :NumbersToggle<CR>
let g:numbers_exclude = ['tagbar', 'gundo', 'nerdtree']

" Syntastic
let g:syntastic_filetype_map = { 'html.twig': 'twiglint' }
" show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>
let g:syntastic_ignore_files = ['\.cpp$', '\.c&']
" check also when just opened the file
" don't put icons on the sign column (it hides the vcs status icons of signify)
let g:syntastic_enable_signs = 0
" custom icons (enable them if you use a patched font, and enable the previous setting)
let g:syntastic_error_symbol = '>>'
let g:syntastic_warning_symbol = '^^'
let g:syntastic_style_error_symbol = '>'
let g:syntastic_style_warning_symbol = '^'

" Signify
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227



" =========================== Custom functions ===============================
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

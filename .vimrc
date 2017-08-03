" ======================== Required configs ==============================
" on windows, setting runtime path to .vim same as *nix system
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

if !has('nvim')
  set nocompatible              " be iMproved, required
endif

call plug#begin('~/.vim/bundle')
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
call plug#end()

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
set clipboard=unnamed
set timeoutlen=1000 ttimeoutlen=0
set laststatus=2

syntax on

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set nospell                         " disable spell checking
set hidden                          " Allow buffer switching without saving
set history=1000                    " Store a ton of history (default is 20)

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set relativenumber
set number                      " Showing line numbers
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=3                " Lines to scroll when cursor leaves screen
set scrolloff=5                 " Minimum lines to keep above and below cursor
set nofoldenable
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

set listchars=tab:›\ ,trail:.,extends:>,nbsp:.,precedes:< " Highlight problematic whitespace
set splitright
set splitbelow
set magic

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
set lazyredraw

set background=dark
let g:gruvbox_contrast_dark = "hard"
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" Base16
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" ======================== GUI configs ==============================
"
hi NonText guifg=bg

" Setting font for GUI otherwise it sets terminal font
if has('gui_running')
  set guioptions-=T           " Remove the toolbar
  set guioptions-=r           " Remove scrollbars
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
    set guioptions-=L
  endif
  "set term=builtin_ansi       " Make arrow and other keys work
endif
if has('nvim')
  set termguicolors
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
  " let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  " Hack to get C-h working in neovim
  nmap <BS> <C-W>h
  tnoremap <Esc> <C-\><C-n>
endif
" ======================== Filetype & Autocmd ==============================

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
au FileType cs set tabstop=4|set shiftwidth=4|set expandtab

autocmd BufNewFile,BufRead *.c,*.h set filetype=c
autocmd BufNewFile,BufRead *.cpp set filetype=cpp
autocmd BufNewFile,BufRead *.php set filetype=php
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *.hbs set filetype=handlebars.html syntax=mustache
autocmd BufNewFile,BufRead *.ts set filetype=typescript
autocmd BufNewFile,BufRead *.xml set filetype=xml

" autocmd BufEnter * sign define dummy
" autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType phtml,html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  " autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
augroup end

" disable folding in javascript
let g:javascript_fold_enabled=1
" =========================== Custom Global Keybindings ===============================
let mapleader = ','
let g:maplocalleader = ';'

" r redo
nmap r <c-r>

" zoom
let g:goyo_width=120
let g:goyo_height='100%'
let g:goyo_linenr=1
" map <leader>z :ZoomWinTabToggle<CR>
map <leader>z :Goyo<CR>

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

" save file
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>

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

" Expand selection
vmap v <Plug>(expand_region_expand)
vmap f <Plug>(expand_region_shrink)

" navigating through tab
map <S-H> gT
map <S-L> gt

" quit
noremap <leader>q :q<cr>
" save and quit
noremap <leader>wq :wq<cr>

" Make the dot command work as expected in visual mode
vnoremap . :norm.<CR>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove"
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" go to end of copy or paste
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]


" Easier horizontal scrolling
map zl zL
map zh zH

" Folding keymap
nnoremap <space><space> za<esc>
vnoremap <space><space> zf

" joining lines
nnoremap Y J

" Need to remap ✠ char to Shift+Enter in iterm2
" Splitting lines
nnoremap ✠ i<CR><Esc>
inoremap ✠ <CR><Esc>O

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

" Disable F1 annoyance
map <F1> <Esc>
imap <F1> <Esc>

" =========================== Plugin configs & Keybindings ===============================
" YouCompleteMe
let g:ycm_key_detailed_diagnostics = ''
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_always_populate_location_list = 1
let g:ycm_warning_symbol = '●'
let g:ycm_error_symbol = '⦿'

" find all references
nnoremap <c-o> :YcmCompleter GoToReferences<cr>
nnoremap <c-i> :YcmCompleter GoToDefinition<cr>
nnoremap <F5> :YcmCompleter GetDoc<cr>

highlight YcmErrorSign ctermbg=237 ctermfg=1

" UltiSnip
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsListSnippets = '<s-tab>'
" let g:UltiSnipsUsePythonVersion = 3
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

" make YCM compatible with UltiSnips (using supertab)
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

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

" vertical line indentation
let g:indentLine_color_term = 237
let g:indentLine_color_gui = '#3a3a3a'
let g:indentLine_char = '│'

" NerdTree
if has('win32') || has('win64')
  let g:NERDTreeCopyCmd= 'cp -r'
endif

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeIgnore=['\.sass-cache$[[dir]]','\.pyc', '\~$', '\.swo$', '\.swp$', '\.git[[dir]]', '\.hg', '\.svn', '\.bzr', '\.scssc', '\.sassc', '^\.$', '^\.\.$', '^Thumbs\.db$', '.DS_Store', '\.meta$']
let NERDTreeMouseMode=0
let NERDTreeChDirMode=2

" Increase tree width slightly
let NERDTreeWinSize = 38
" Change working directory to the root automatically

nmap <F4> :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeFind<CR>

"Vim-Go
let g:go_disable_autoinstall = 0
"" Highlight
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

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
" ctrlP
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_map=''
nnoremap <silent> <C-p> :CtrlP<CR>
nnoremap <silent> <C-b> :CtrlPBuffer<CR>

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](node_modules|bower_components|dist|tmp)|(\.(git|hg|svn|sassc))$',
      \ 'file': '\v\.(exe|so|dll|png|jpg|gif|jpeg|swf|pdf|mp3)$'
      \}
let g:ctrlp_extensions = ['funky']

" Silver search
let g:ag_working_path_mode="r"

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

" rainbow
let g:rainbow_active = 1

"vim-flow
let g:flow#autoclose = 1

" auto session save
let g:session_autosave = 'no'
let g:session_autoload = 'yes'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
set completeopt-=preview

" nmap <F5> :TagbarToggle<CR>

" Gundo history tree
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
nnoremap <F6> :GundoToggle<CR>

"vim-json
let g:vim_json_syntax_conceal = 0

" Numbers
let g:numbers_exclude = ['tagbar', 'gundo', 'nerdtree']

" jscs returns exit code when no config file is present.
" Only load it when appropriate.
let g:jsx_ext_required = 0

" enable zen coding on jsx
autocmd FileType javascript.jsx runtime! ftplugin/html/sparkup.vim

function! NeomakeESlintChecker()
  let l:npm_bin = ''
  let l:eslint = 'eslint'

  if executable('npm')
    let l:npm_bin = split(system('npm bin'), '\n')[0]
  endif

  if strlen(l:npm_bin) && executable(l:npm_bin . '/eslint')
    let l:eslint = l:npm_bin . '/eslint'
    let b:neomake_javascript_eslint_exe = l:eslint
    let g:neomake_javascript_enabled_makers= ['eslint']
    let g:neomake_jsx_enabled_makers= ['eslint']
  endif

endfunction

if has('nvim')
	let g:neomake_typescript_enabled_makers = ['tslint']
	let g:neomake_scss_enabled_makers = ['stylelint']
	let g:neomake_scss_stylelint_maker = {
	\ 'exe': split(system('npm-which stylelint'))[0],
	\ 'args': ['--syntax', 'scss'],
	\ 'errorformat':
		\ '%+P%f,' .
			\ '%*\s%l:%c  %t  %m,' .
		\ '%-Q'
	\ }

	let g:neomake_css_enabled_makers = ['stylelint']
	let g:neomake_css_stylelint_maker = {
	\ 'exe': split(system('npm-which stylelint'))[0],
	\ 'errorformat':
		\ '%+P%f,' .
			\ '%*\s%l:%c  %t  %m,' .
		\ '%-Q'
	\ }

  let test#strategy = "neovim"

	autocmd FileType javascript :call NeomakeESlintChecker()
	autocmd FileType javascript.jsx :call NeomakeESlintChecker()

	autocmd! BufWritePost,BufReadPost * Neomake

  let g:neomake_list_height=5
  let g:neomake_place_signs=1

  let g:neomake_warning_sign = {
        \ 'text': '●',
        \ 'texthl': 'NeomakeWarningMsg',
        \ }
  "
  let g:neomake_error_sign = {
        \ 'text': '⦿',
        \ 'texthl': 'ErrorMsg',
        \ }
else
  " Syntastic
  let test#strategy = "dispatch"

  function! JavascriptCheckers()
    if filereadable(getcwd() . '/.jscsrc')
      return ['eslint', 'jscs']
    else
      return ['eslint']
    endif
  endfunction

  " check also when just opened the file
  let g:syntastic_check_on_open = 1
  let g:syntastic_filetype_map = { 'html.twig': 'twiglint' }
  let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
  let g:syntastic_javascript_checkers = JavascriptCheckers()
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_loc_list_height = 5
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_filetype_map = { 'hbs': 'handlebars' }

  " don't put icons on the sign column (it hides the vcs status icons of signify)
  let g:syntastic_enable_signs = 0
  " custom icons (enable them if you use a patched font, and enable the previous setting)
  let g:syntastic_error_symbol = '>>'
  let g:syntastic_warning_symbol = '^^'
  let g:syntastic_style_error_symbol = '>'
  let g:syntastic_style_warning_symbol = '^'
endif

" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,chai,handlebars,underscore,react'

" Handlebars
let g:mustache_abbreviations = 1

" Git Gutter
let g:gitgutter_override_sign_column_highlight = 0
" let g:gitgutter_sign_column_always = 1
set signcolumn=yes
nmap <Leader>hk <Plug>GitGutterPreviewHunk

" Easy Motion
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap <space>s <Plug>(easymotion-s)
" or `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap <Leader>s <Plug>(easymotion-s2)


" JK motions: Line motions
nmap <space>w <Plug>(easymotion-lineforward)
nmap <space>j <Plug>(easymotion-j)
nmap <space>k <Plug>(easymotion-k)
nmap <space>b <Plug>(easymotion-linebackward)

nnoremap <Leader>w :w<cr><Space>
" JS-Beautify
noremap <c-f> :Autoformat<CR>


" =========================== Custom functions ===============================
" Show highlight group current location
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

" vim-move
let g:move_key_modifier = 'S'

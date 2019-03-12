" ======================== Required configs ==============================
set nocompatible              " be iMproved, required

call plug#begin('~/.vim/bundle')
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
call plug#end()

filetype plugin indent on    " required

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
set nottimeout
set laststatus=2

syntax on

set shortmess+=filmnrxoOtTc          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set nospell                         " disable spell checking
set hidden                          " Allow buffer switching without saving
set cmdheight=1
set history=1000                    " Store a ton of history (default is 20)
set updatetime=300

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

set sessionoptions+=tabpages,globals
set sessionoptions-=buffers

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
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu
" colorscheme jellybeans
" ======================== GUI configs ==============================
"
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

" ======================== Filetype & Autocmd ==============================

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
" Automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <A-space> coc#refresh()

" projectionist
let g:fuzzy_projectionist_preview = 1

" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" vim-move
let g:move_key_modifier = 'S'

" disable folding in javascript
let g:javascript_fold_enabled=1
" =========================== Custom Global Keybindings ===============================
let mapleader = ','
let g:maplocalleader = ';'

" r redo
nmap r <c-r>

" Remap keys for gotos
nmap <leader>d <Plug>(coc-definition)
" nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>u <Plug>(coc-references)

" Remap for rename current word
nmap <leader>r <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> <localleader>d :call <SID>show_documentation()<CR>

nnoremap <localleader>c :Fmodule<cr>
nnoremap <localleader>m :Fmodel<cr>
nnoremap <localleader>g :Fgql<cr>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_emptyTags_caseSensitive = 1

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

" save file
nnoremap <leader>w :w<cr>
inoremap <leader>w <C-c>:w<cr>

" no highlight after press enter
nnoremap <CR> :nohlsearch<cr>

" switch between last buffer
nnoremap <leader><leader> <c-^>

" easier navigation between split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" Expand selection
vmap v <Plug>(expand_region_expand)
vmap f <Plug>(expand_region_shrink)

" navigating through tab
nnoremap <S-h> gT
nnoremap <S-l> gt

" quit & save
noremap <leader>q :q<cr>
nnoremap <leader>w :w<cr><Space>

" Make the dot command work as expected in visual mode
vnoremap . :norm.<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Moving line
nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==
vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

nnoremap [ :lprev<cr>
nnoremap ] :lnext<cr>

inoremap <c-c> <ESC>

" " Use <TAB> to select the popup menu:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" vim-test
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>T :TestSuite<CR>

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

" better whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" Disabling arrow key motions
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable F1 annoyance
map <F1> <Esc>
imap <F1> <Esc>

" =========================== Plugin configs & Keybindings ===============================
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$HOME."/.vim/UltiSnips"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/UltiSnips"]
" let g:UltiSnipsExpandTrigger='<Tab>'
" let g:UltiSnipsJumpForwardTrigger='<c-n>'
" let g:UltiSnipsJumpBackwardTrigger='<c-p>'

"Airline
let g:airline_powerline_fonts  = 1
let g:airline_theme            = 'ayu'
let g:airline#extensions#hunks#enabled = 0

" only showing filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Ag
let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
let g:fzf_layout = { 'down': '~20%' }

" PIV
let g:DisableAutoPHPFolding = 1
let g:PIVAutoClose = 0

" Misc
let b:match_ignorecase = 1

let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

" vertical line indentation
let g:indentLine_color_term = 237
let g:indentLine_color_gui = '#3a3a3a'
let g:indentLine_char = '│'

let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeIgnore=[
      \ '\.idea', '\.sass-cache$[[dir]]','\.pyc', '\~$', '\.swo$', '\.swp$',
      \ '\.git[[dir]]', '\.hg', '\.svn', '\.bzr', '\.scssc', '\.sassc', '^\.$', '^\.\.$',
      \ '^Thumbs\.db$', '.DS_Store', '\.meta$', 'node_modules'
      \ ]
let NERDTreeMouseMode=1
let NERDTreeChDirMode=2

" Increase tree width slightly
let NERDTreeWinSize = 40
" Change working directory to the root automatically
"
let g:lt_location_list_toggle_map = '<F2>'
let g:lt_quickfix_list_toggle_map = '<F3>'
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

" Prettier
nmap <Leader>ff <Plug>(Prettier)

" Figutive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :GV<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>

" session saved to default
nnoremap <silent> <leader>ss :SaveSession<CR>
nnoremap <silent> <leader>sd :DeleteSession<CR>

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
autocmd FileType nerdtree setlocal signcolumn=no
" autocmd FileType json syntax match Comment +\/\/.\+$+
" let g:DevIconsEnableFolderPatternMatching = 1
" let g:NERDTreeHighlightFolders = 1
" let g:NERDTreeHighlightFoldersFullName = 1
let g:webdevicons_enable_airline_tabline = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsNerdTreeAfterGlyphPadding = "  "


" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
" let g:NERDTreePatternMatchHighlightFullName = 1

" ale
let g:ale_sign_error = '⦿'
let g:ale_sign_warning = '●'
let g:ale_lint_on_text_changed = 'never'

" rainbow
let g:rainbow_active = 1

" auto session save
let g:session_autosave = 'no'
let g:session_autoload = 'yes'

" Taboo tabline
let g:taboo_renamed_tab_format = " %l %m "

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
" set completeopt-=preview

" nmap <F5> :TagbarToggle<CR>

" Gundo history tree
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
nnoremap <F6> :GundoToggle<CR>

"vim-json
let g:vim_json_syntax_conceal = 0

" Numbers
let g:numbers_exclude = ['tagbar', 'gundo', 'nerdtree']

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" enable zen coding on jsx
autocmd FileType javascript.jsx runtime! ftplugin/html/sparkup.vim
autocmd FileType typescript.tsx runtime! ftplugin/html/sparkup.vim

" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,chai,handlebars,underscore,react'

" Git Gutter
let g:gitgutter_override_sign_column_highlight = 0
" let g:gitgutter_sign_column_always = 1
set signcolumn=yes
nmap <Leader>hk <Plug>GitGutterPreviewHunk

" Easy Motion
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" JK motions: Line motions
nmap <space>s <Plug>(easymotion-overwin-f)
nmap <space>w <Plug>(easymotion-lineforward)
nmap <space>j <Plug>(easymotion-j)
nmap <space>k <Plug>(easymotion-k)
nmap <space>b <Plug>(easymotion-linebackward)


" =========================== Custom functions ===============================
" Show highlight group current location
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

function! FZFWithDevIcons()
  let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up '
        \.'--preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let result = []
    for candidate in a:candidates
      let filename = fnamemodify(candidate, ':p:t')
      let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
      call add(result, printf("%s  %s", icon, candidate))
    endfor

    return result
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = items[i]
      let parts = split(item, '  ')
      let file_path = get(parts, 1, '')
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let opts = fzf#wrap({})
  let opts.source = <sid>files()
  let s:Sink = opts['sink*']
  let opts['sink*'] = function('s:edit_file')
  let opts.options .= l:fzf_files_options
  call fzf#run(opts)
endfunction

map <C-p> :call FZFWithDevIcons()<CR>

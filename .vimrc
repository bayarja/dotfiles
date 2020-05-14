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
set ttimeout
set ttimeoutlen=0
set laststatus=2

syntax on

set shortmess+=filmnrxoOtTc          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=cursor,folds,slash,unix " Better Unix / Windows compatibility
set nospell                         " disable spell checking
set hidden                          " Allow buffer switching without saving
set history=1000                    " Store a ton of history (default is 20)
set updatetime=300

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
" set relativenumber
set number                      " Showing line numbers
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set undofile
set wildmode=longest:full,full  " Command <Tab> completion, list matches, then longest common part, then all.
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
set sessionoptions-=folds

set nowrap                      " No Wrap long lines
set synmaxcol=512
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 2 spaces
set expandtab                   " Tabs are spaces, not tabs

set tabstop=2                   " An indentation every four columns
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
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors
colorscheme one


" ======================== Filetype & Autocmd ==============================
augroup autocmds
  autocmd!
  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
  autocmd BufNewFile,BufRead *rc setlocal filetype=json
  autocmd BufNewFile,BufRead .vimrc setlocal filetype=vim

  " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

  autocmd FileType html,css,javascript.jsx,typescript.tsx EmmetInstall

  autocmd! FileType fzf
  au FileType fzf set nonu nornu

  autocmd FileType json syntax match Comment +\/\/.\+$+
  " enable zen coding on jsx
  autocmd FileType typescript runtime! ftplugin/html/sparkup.vim
  autocmd FileType javascript.jsx runtime! ftplugin/html/sparkup.vim
  autocmd FileType typescript.tsx runtime! ftplugin/html/sparkup.vim

  " autocmd FileType defx call s:defx_my_settings()
  autocmd FileType defx call s:defx_my_settings()
  autocmd FileType typescript.tsx let b:pear_tree_pairs = {
      \ '(': {'closer': ')'},
      \ '[': {'closer': ']'},
      \ '{': {'closer': '}'},
      \ "'": {'closer': "'"},
      \ '"': {'closer': '"'},
      \ '<*>': {'closer': '</*>', 'not_like': '=\|/$'}
      \ }
augroup END

" projectionist
let g:fuzzy_projectionist_preview = 1

" vim-test
let test#strategy = "neovim"

" vim-move
let g:move_key_modifier = 'S'

" =========================== Custom Global Keybindings ===============================
let mapleader = ','

" r redo
nmap r <c-r>

" Remap keys for gotos
nmap <silent>; <Plug>(coc-diagnostic-info)
nmap <leader>d <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>u <Plug>(coc-references)
nmap <leader>a <Plug>(coc-codeaction)
vmap <leader>a  <Plug>(coc-codeaction-selected)
"  Remap for rename current word
nmap <leader>r <Plug>(coc-rename)

nmap <silent> [ <Plug>(coc-diagnostic-prev)
nmap <silent> ] <Plug>(coc-diagnostic-next)
nnoremap <silent><c-o> :call CocAction('runCommand', 'tsserver.organizeImports')<CR>
nnoremap <silent><f9> :call CocAction('runCommand', 'tsserver.restart')<CR>

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use K for show documentation in preview window
nnoremap <silent> t :call <SID>show_documentation()<CR>
nmap <silent>; :<C-u>CocList diagnostics<cr>
" nmap <silent>; <Plug>(coc-action-diagnosticInfo)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" zoom
let g:goyo_width=120
let g:goyo_height='100%'
let g:goyo_linenr=1
command! -nargs=? -bar -bang Goyo call goyo#execute(<bang>0, <q-args>)
map <leader>o :Goyo<CR>

" " Zoom / Restore window.
" function! s:ZoomToggle() abort
"   if exists('t:zoomed') && t:zoomed
"     execute t:zoom_winrestcmd
"     let t:zoomed = 0
"   else
"     let t:zoom_winrestcmd = winrestcmd()
"     resize
"     vertical resize
"     let t:zoomed = 1
"   endif
" endfunction
"
" command! ZoomToggle call s:ZoomToggle()
" nnoremap <silent> <leader>o :ZoomToggle<CR>

" Preserve indentation while pasting text from the clipboard
noremap <leader>p :set paste<CR>:put  +<CR>:set nopaste<CR>

" save file
nnoremap <leader>w :w<cr>
inoremap <leader>w <C-c>:w<cr>

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

" navigating through tab
nnoremap <S-h> gT
nnoremap <S-l> gt

" quit & save
nnoremap <silent>;q :Bwipeout<cr>
nnoremap <leader>q :q<cr>
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

" vim-test
nmap <silent> ;t :TestFile<CR>
nmap <silent> ;T :TestSuite<CR>

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

let g:smartpairs_start_from_word = 1
let g:smartpairs_revert_key = 'f'

" Disabling arrow key motions
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable F1 annoyance
map <F1> <Esc>
imap <F1> <Esc>

" =========================== Plugin configs & Keybindings ===============================
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetsDir=$HOME."/.vim/UltiSnips"
" let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/UltiSnips"]
" let g:UltiSnipsExpandTrigger='<Tab>'
" let g:UltiSnipsJumpForwardTrigger='<c-n>'
" let g:UltiSnipsJumpBackwardTrigger='<c-p>'


" emmet
let g:user_emmet_install_global=0

let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>y :call WindowSwap#EasyWindowSwap()<CR>

"Airline
let g:airline_powerline_fonts  = 1
let g:airline_theme            = 'one'
let g:airline_section_c = '%t'
let g:airline_section_b = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#hunks#enabled = 0

let g:airline_mode_map = {
      \ '__' : '-',
      \ 'c'  : 'C',
      \ 'i'  : 'I',
      \ 'ic' : 'I',
      \ 'ix' : 'I',
      \ 'n'  : 'N',
      \ 'ni' : 'N',
      \ 'no' : 'N',
      \ 'R'  : 'R',
      \ 'Rv' : 'R',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ 't'  : 'T',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ }
" only showing filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Rg
set grepprg=rg\ --vimgrep

let $FZF_DEFAULT_COMMAND = 'rg --files --fixed-strings --hidden --follow --glob "!.git/*"'
command! -bang -nargs=* Find call fzf#vim#grep('rg
      \ --column --line-number --no-heading
      \ --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --glob "!*.lock" --glob "!*-lock.json"
      \ --colors "path:fg:118,137,168" --colors "line:fg:97,175,239" --colors "match:fg:0,0,0"
      \ --color "always" '.shellescape(<q-args>).' | tr -d "\017"', 1,
      \{ 'options': '--color fg:#ABB2BF,hl:#61afef,fg+:#ffae57,bg+:-1,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174' }, <bang>0
      \)

"171,178,191 ABB2BF
"118,137,168 7689A8
" let g:fzf_layout = { 'down': '~20%' }
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let width = float2nr(&columns - (&columns * 2 / 10) * 2)
  let height = &lines - 25
  let y = &lines - 3
  let x = float2nr((&columns - width) / 2)

  let opts = {
	\ 'relative': 'editor',
	\ 'row': y,
	\ 'col': x,
	\ 'width': width,
	\ 'height': height
	\ }

  call nvim_open_win(buf, v:true, opts)
endfunction

let g:fzf_buffers_jump = 1

" PIV
let g:DisableAutoPHPFolding = 1
let g:PIVAutoClose = 0

" startify
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_files_number = 5
let g:startify_padding_left = 50
let g:ascii = [
      \ '',
      \ '',
      \ '',
      \'                                                   __    __  ________   ______   __     __  ______  __       __',
      \'                                                  /  \  /  |/        | /      \ /  |   /  |/      |/  \     /  |',
      \'                                                  $$  \ $$ |$$$$$$$$/ /$$$$$$  |$$ |   $$ |$$$$$$/ $$  \   /$$ |',
      \'                                                  $$$  \$$ |$$ |__    $$ |  $$ |$$ |   $$ |  $$ |  $$$  \ /$$$ |',
      \'                                                  $$ $$ $$ |$$$$$/    $$ |  $$ | $$  /$$/    $$ |  $$ $$ $$/$$ |',
      \'                                                  $$ | $$$ |$$       |$$    $$/    $$$/    / $$   |$$ | $/  $$ |',
      \'                                                  $$/   $$/ $$$$$$$$/  $$$$$$/      $/     $$$$$$/ $$/      $$/',
      \ '',
      \ '',
      \ '',
      \ '',
      \]
let g:startify_custom_header = g:ascii
" let g:startify_custom_header =
"             \ map(split(system('fortune | cowsay'), '\n'), '"   ". v:val')

" vertical line indentation
let g:indentLine_color_term = 237
let g:indentLine_color_gui = '#3a3a3a'
let g:indentLine_char = '│'
let g:indentLine_fileType = ['typescript', 'javascript', 'typescript.tsx', 'javascript.jsx', 'php', 'phtml']
let g:indentLine_bufTypeExclude = ['help', 'terminal']

let g:lt_location_list_toggle_map = '<F2>'
let g:lt_quickfix_list_toggle_map = '<F3>'

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
nnoremap <silent> <leader>ss :SSave<CR>
nnoremap <silent> <leader>sd :SDelete<CR>

let g:webdevicons_enable = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsOS = 'Darwin'

" let g:DevIconsEnableFolderPatternMatching = 1
let g:matchup_matchparen_enabled = 0

" match tag always
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0

" Gundo history tree
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
nnoremap <F6> :GundoToggle<CR>

"vim-json
let g:vim_json_syntax_conceal = 0
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_pairs = {
      \ '(': {'closer': ')'},
      \ '[': {'closer': ']'},
      \ '{': {'closer': '}'},
      \ "'": {'closer': "'"},
      \ '"': {'closer': '"'},
      \ }

" Numbers
let g:numbers_exclude = ['gundo']



" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,chai,handlebars,underscore,react,react-dom'

" Git Gutter
let g:gitgutter_override_sign_column_highlight = 0
" let g:gitgutter_sign_column_always = 1
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

nnoremap <silent>% :MtaJumpToOtherTag<cr>

" =========================== Custom colors ===============================
call one#highlight('CocCodeLens', '5c6370', '', 'none')
call one#highlight('Search', 'f0f2f4', '4d5566', 'none')
call one#highlight('IncSearch', 'f0f2f4', '4d5566', 'none')
call one#highlight('VertSplit', '3a424f', '', 'none')
call one#highlight('doxygenBrief', '5c6370', '', 'none')
call one#highlight('jsonQuote', '919baa', '', 'none')
call one#highlight('EndOfBuffer', '282c34', '', 'none')
call one#highlight('CocErrorFloat', 'ff3f3f', '', 'none')
call one#highlight('NonText', '282c34', '', 'none')

" yellow
call one#highlight('Label', 'e5c07b', '', 'none')
call one#highlight('Keyword', 'e5c07b', '', 'none')
call one#highlight('Identifier', 'e5c07b', '', 'none')
call one#highlight('typescriptParenExp', 'e5c07b', '', 'none')
call one#highlight('typescriptConditionalParen', 'e5c07b', '', 'none')

" cyan
call one#highlight('typescriptMember', '88cee8', '', 'none')
call one#highlight('StartifyHeader', '88cee8', '', 'none')
call one#highlight('typescriptObjectLabel', '88cee8', '', 'none')
call one#highlight('graphqlName', '88cee8', '', 'none')
call one#highlight('jsoncString', '88cee8', '', 'none')

" dark orange
call one#highlight('javascriptTemplateSB', 'ffae57', '', 'none')
call one#highlight('typescriptTemplateSB', 'ffae57', '', 'none')
call one#highlight('typescriptReact', 'ffae57', '', 'none')
call one#highlight('typescriptVariableDeclaration', 'ffae57', '', 'none')
call one#highlight('typescriptClassName', 'ffae57', '', 'none')
call one#highlight('Defx_filename_3_nested_opened_tree_icon', 'ffae57', '', 'none')

" blue
call one#highlight('MatchTag', '61afef', '', 'underline,bold')
call one#highlight('xmlTag', '61afef', '', 'none')
call one#highlight('xmlTagName', '61afef', '', 'none')
call one#highlight('xmlEndTag', '61afef', '', 'none')
call one#highlight('tsxTagName', '61afef', '', 'none')
call one#highlight('tsxCloseString', '61afef', '', 'none')
call one#highlight('htmlTag', '61afef', '', 'none')
call one#highlight('htmlTagName', '61afef', '', 'none')
call one#highlight('htmlEndTag', '61afef', '', 'none')
call one#highlight('jsonKeyword', '61afef', '', 'none')
call one#highlight('graphqlType', '61afef', '', 'none')
call one#highlight('typescriptRProps', '61afef', '', 'none')
call one#highlight('typescriptClassHeritage', '61afef', '', 'none')
call one#highlight('typescriptFuncCallArg', '61afef', '', 'none')

" green
call one#highlight('embeddedTs', '98c379', '', 'none')
call one#highlight('Defx_filename_3_parent_directory', '98c379', '', 'none')

call one#highlight('typescriptCall', '56b6c2', '', 'none')
call one#highlight('typescriptVariable', '56b6c2', '', 'none')


" purple
call one#highlight('typescriptAmbientDeclaration', 'c678dd', '', 'none')
call one#highlight('typescriptClassStatic', 'c678dd', '', 'none')
call one#highlight('typescriptClassKeyword', 'c678dd', '', 'none')
call one#highlight('typescriptAliasKeyword', 'c678dd', '', 'none')
call one#highlight('typescriptExport', 'c678dd', '', 'none')
call one#highlight('typescriptOperator', 'c678dd', '', 'none')
call one#highlight('typescriptClassExtends', 'c678dd', '', 'none')
call one#highlight('graphqlDirective', 'c678dd', '', 'none')

" red
call one#highlight('MatchParen', 'e69176', '', 'bold')
call one#highlight('Structure', 'e69176', '', 'none')
call one#highlight('typescriptInterfaceName', 'e06c75', '', 'none')

" =========================== Custom functions ===============================
" Show highlight group current location
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

function! FZFWithDevIcons()
  let l:fzf_files_options = ' --color fg:#7689A8,hl:#61afef,fg+:#ffae57,bg+:-1,hl+:229
	\ --color info:150,prompt:110,spinner:150,pointer:167,marker:174
	\ -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up'
	\.' --preview "bat --theme=OneHalfDark --color always --style numbers {2..}"'

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

nmap <C-p> :call FZFWithDevIcons()<CR>
nmap <C-f> :Find<cr>
nmap <C-b> :Buffers<CR>

let g:loaded_netrwPlugin = 1 " Disable netrw.vim

let g:defx_icons_directory_icon = ''
let g:defx_icons_column_length = 2
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_mark_icon = '•'
let g:defx_icons_parent_icon = ''

call defx#custom#option('_', {
      \ 'root_marker': '» ',
      \ 'buffer_name': '',
      \ 'columns': 'indent:mark:icons:filename',
      \ })

call defx#custom#column('filename', {
      \ 'min_width': 36,
      \ 'max_width': 36,
      \ })
call defx#custom#column('indent', {
      \ 'indent': '  ',
      \ })

function! s:defx_my_settings() abort

  function! Root(path) abort
    return fnamemodify(a:path, ':t')
  endfunction

  call defx#custom#source('file', {
	\ 'root': 'Root',
	\})
  " Open commands
  " nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
  nnoremap <silent><buffer><expr> o
	\ defx#is_directory() ?
	\ defx#do_action('open_or_close_tree') :
	\ defx#do_action('open', 'wincmd w \| drop')

  " nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> s defx#do_action('open', 'wincmd w \| vsplit \| drop')
  nnoremap <silent><buffer><expr> i defx#do_action('open', 'wincmd w \| split \| drop')
  " Preview current file
  " nnoremap <silent><buffer><expr> s defx#do_action('open', 'pedit')

  " File manipulation
  nnoremap <silent><buffer><expr> ma defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> md defx#do_action('remove')
  nnoremap <silent><buffer><expr> mr defx#do_action('rename')
  nnoremap <silent><buffer><expr> mc defx#do_action('multi', ['copy', 'paste'])
  nnoremap <silent><buffer><expr> mm defx#do_action('move')
  nnoremap <silent><buffer><expr> mp defx#do_action('paste')

  "Navigation
  nnoremap <silent><buffer><expr> p defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> l defx#do_action('open')
  nnoremap <silent><buffer><expr> <cr> defx#do_action('open')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> <s-u> defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd', [getcwd()])
  nnoremap <silent><buffer><expr> <s-t> defx#do_action('open', 'tabnew \| drop')

  " Miscellaneous actions
  nnoremap <silent><buffer><expr> <s-i> defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> mo defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yp defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> <C-r> defx#do_action('redraw') . ':syntax sync fromstart<cr><c-l>'

  nnoremap <silent><buffer><expr><nowait> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')

  nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:size:filename')
endfunction

nnoremap <silent><leader>nf :Defx -new `expand('%:p:h')` -search=`expand('%:p')`<CR>
nnoremap <silent><leader>nt :Defx -resume -split=vertical -winwidth=40
      \ -direction=topleft -search=`expand('%:p')` `getcwd()`<CR>
nnoremap <silent><f4> :Defx -toggle -split=vertical -winwidth=40 -direction=topleft -resume<CR>

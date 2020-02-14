" GENERAL SETTINGS
" =============================================================


set nocompatible

let mapleader="\\"
let maplocalleader="'"

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>tv :tabedit $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set autoindent
set autoread
set backspace=indent,eol,start
set expandtab
set fileformat=unix
set hidden
set history=500
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set matchpairs+=<:>
set modeline
set modelines=5
set mousehide
set noesckeys
set nofoldenable
set nojoinspaces
set nostartofline
set ruler
set shell=/bin/bash
set shiftround
set shiftwidth=4
set showcmd
set showmode
set sidescroll=1
set smartcase
set smarttab
set softtabstop=4
set splitbelow
set splitright
set textwidth=79
set ttyfast
set virtualedit=all
set visualbell
set wildmenu
set wrapscan

if has("multi_byte")
    set encoding=utf-8
    set fillchars=diff:⣿
    set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪
else
    set showbreak=>
endif

" Fix problems with dtterm TERM type.
if &term == "dtterm"
    set t_kb=
    set t_Co=256
    fixdel
endif


" MAPPINGS & FUNCTIONS
" =============================================================

" Display buffer number
nnoremap <Leader>B :echo bufnr('%')<CR>

" Split line at cursor
nnoremap <Leader>k i<CR><Esc>
nnoremap <Leader>K r<CR><Esc>

" Clear highlighting and redraw.
nnoremap <C-l> :nohlsearch<CR><C-l>
inoremap <C-l> <C-o>:nohlsearch<CR>

" Call help on the word under cursor.
nnoremap <Leader>h :execute "help " . expand("<cword>")<CR>

" Toggle paste mode and show result.
nnoremap <Leader>p :set invpaste paste?<CR>

" Insert the current time.
imap <C-t> <C-r>=strftime("%H:%M - ")<CR>

" Insert the current date.
imap <C-d> <C-r>=strftime("# %Y %b %d %a")<CR>

" Write to the current file with root permissions via sudo.
cnoremap w!! w !sudo tee % >/dev/null<CR>

" Toggle line wrapping and show result.
nnoremap <Leader>w :set invwrap wrap?<CR>

" Toggle highlight the current line of the cursor.
nnoremap <Leader>u :set cursorcolumn! cursorline!<CR>

" Toggle moving cursor to first non-blank of line and show result.
nnoremap <Leader>s :set startofline! startofline?<CR>

" Switch between tabs.
nnoremap <Right> gt
nnoremap <Left> gT

" Remove manual key.
nnoremap K <Nop>

" Edit my vimrc file.
nnoremap <Leader>ev :split $MYVIMRC<CR>

" Source my vimrc file.
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Toggle list and number.
if (&relativenumber == 1)
    nnoremap <Leader>$ :set list! number!<CR>
else
   nnoremap <Leader>$ :set list! relativenumber!<CR>
endif

" Make Y behave like other capitals.
nnoremap Y y$

" Reselect previous visual block after an indent, or outdent.
vnoremap < <gv
vnoremap > >gv

" Remove all trailing whitespace.
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Keep search matches in the middle of the screen when moving.
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz

" Rename the current file.
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

map <Leader>R :call RenameFile()<CR>

" Delete the current file.
function! DeleteFile()
    let fname = expand('%')
    exec ':bdelete!'
    exec ':silent !rm -f ' . fname
    redraw!
endfunction

map <Leader>D :call DeleteFile()<CR>

" Run tests.
function! RunTestUnderCursor()
    :write
    if (match(expand("%"), '_spec.rb$') != -1) || (match(expand("%"), '.feature$') != -1)
        let t:my_test_file = @%
        let t:my_test_line_number = line('.')
    endif

    if (!exists("t:my_test_file") || !exists("t:my_test_line_number"))
        echo "ERROR: test file, or test line number does not exist."
        return
    endif

    if (match(t:my_test_file, '_spec.rb') != -1)
        execute "!clear; bundle exec rspec -f d " . t:my_test_file . ":" . t:my_test_line_number
    else
        execute "!clear; bundle exec cucumber " . t:my_test_file . ":" . t:my_test_line_number . " -r features"
    endif
endfunction

function! RunTestFile()
    :write
    if (match(expand("%"), '_spec.rb$') != -1) || (match(expand("%"), '.feature$') != -1)
        let t:my_test_file = @%
    endif

    if !exists("t:my_test_file")
        echo "ERROR: test file does not exist."
        return
    endif

    if (match(t:my_test_file, '_spec.rb') != -1)
        execute "!clear; bundle exec rspec -f d " . t:my_test_file
    else
        execute "!clear; bundle exec cucumber " . t:my_test_file . " -r features"
    endif
endfunction

nnoremap <Leader>T :call RunTestFile()<CR>
nnoremap <Leader>t :call RunTestUnderCursor()<CR>

" Like windo but restore the current window.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
command! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Like bufdo but restore the current buffer.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
command! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Like tabdo but restore the current tab.
function! TabDo(command)
  let currTab=tabpagenr()
  execute 'tabdo ' . a:command
  execute 'tabn ' . currTab
endfunction
command! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)

" PATHOGEN SETUP
" =============================================================


try
    call pathogen#infect()
catch /^Vim\%((\a\+)\)\=:E/
    " Ignore errors if pathogen can't be found.
endtry


" COLOR SETUP
" =============================================================


" Color & syntax settings.
if &t_Co > 1 | syntax on | endif

if has('gui_running')
    set background=light
    " set background=dark
else
    set background=dark
endif

if &t_Co > 255
    let g:solarized_termcolors=256
elseif &t_Co > 15
    let g:solarized_termcolors=16
endif

let g:solarized_contrast="high"
let g:solarized_termtrans=1

" some badwolf specific settings:
" Make the gutters darker than the background.
" let g:badwolf_darkgutter = 1

" Make the tab line much lighter than the background.
" let g:badwolf_tabline = 3

" Turn on CSS properties highlighting
" let g:badwolf_css_props_highlight = 1

try
    if has('gui_running')
        " colorscheme solarized
        colorscheme github
        " colorscheme gruvbox
        " color badwolf
        " colorscheme Tomorrow
        " colorscheme wombat
        " colorscheme railscasts
        " colorscheme pyte
    elseif  &t_Co > 15
        colorscheme solarized
        " colorscheme gruvbox
        " color badwolf
        " colorscheme pyte
        " colorscheme wombat
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    " Ignore errors if solarized can't be found.
endtry

if exists("g:colors_name") && g:colors_name == 'solarized' && has("multi_byte")
    highlight! NonText ctermfg=235
endif


" FILE TYPE SETTINGS & AUTOCMD GROUPS
" =============================================================


" Enable filetype specific indenting.
filetype indent on

" Enable filetype specific plugins.
filetype plugin on

" Use Tabularize to align pipe delimited tables (e.g. in Cucumber features).
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

augroup ag_all
    autocmd!
    autocmd BufRead * normal zz
    autocmd BufReadPost fugitive://* set bufhidden=delete

    if has("multi_byte") && &t_Co > 255
        autocmd FileType * setlocal list

        if (&relativenumber == 1)
           autocmd FileType * setlocal number
        else
           autocmd FileType * setlocal relativenumber
        endif
    endif

    autocmd InsertLeave * set nopaste
augroup END

augroup ag_c
    autocmd!
    autocmd FileType c setlocal noexpandtab
    autocmd FileType c setlocal nolist
    if (&relativenumber == 1)
        autocmd FileType c setlocal nonumber
    else
       autocmd FileType c setlocal norelativenumber
    endif
    autocmd FileType c setlocal shiftwidth=8
    autocmd FileType c setlocal softtabstop=0
    autocmd Filetype c setlocal omnifunc=ccomplete#Complete
augroup END

augroup ag_coffee
    autocmd!
    autocmd FileType coffee setlocal expandtab
    autocmd FileType coffee setlocal shiftwidth=2
    autocmd FileType coffee setlocal softtabstop=2
augroup END

augroup ag_haml
    autocmd!
    autocmd FileType haml setlocal iskeyword+=-
augroup END

augroup ag_css
    autocmd!
    autocmd FileType css setlocal expandtab
    autocmd FileType css setlocal shiftwidth=2
    autocmd FileType css setlocal softtabstop=2
    autocmd FileType css setlocal omnifunc=csscomplete#Complete
    autocmd FileType css setlocal iskeyword+=-
augroup END

augroup ag_cucumber
    autocmd!
    autocmd FileType cucumber inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
    autocmd FileType cucumber setlocal expandtab
    autocmd FileType cucumber setlocal shiftwidth=2
    autocmd FileType cucumber setlocal softtabstop=2
augroup END

augroup ag_eruby
    autocmd!
    autocmd FileType eruby setlocal expandtab
    autocmd FileType eruby setlocal shiftwidth=2
    autocmd FileType eruby setlocal softtabstop=2
augroup END

augroup ag_eco
    autocmd!
    autocmd FileType eco setlocal expandtab
    autocmd FileType eco setlocal shiftwidth=2
    autocmd FileType eco setlocal softtabstop=2
augroup END

augroup ag_jeco
    autocmd!
    autocmd BufNewFile,BufRead *.jeco exec "let b:eco_subtype = 'html' | setlocal filetype=eco"
    autocmd FileType eco setlocal expandtab
    autocmd FileType eco setlocal shiftwidth=2
    autocmd FileType eco setlocal softtabstop=2
augroup END

augroup ag_gemfile
    autocmd!
    autocmd BufRead,BufNewFile Gemfile setlocal ft=ruby
    autocmd FileType Gemfile setlocal expandtab
    autocmd FileType Gemfile setlocal shiftwidth=2
    autocmd FileType Gemfile setlocal softtabstop=2
augroup END

augroup ag_gitconfig
    autocmd!
    autocmd FileType gitconfig setlocal expandtab
    autocmd FileType gitconfig setlocal shiftwidth=8
    autocmd FileType gitconfig setlocal softtabstop=8
augroup END

augroup ag_gitcommit
    autocmd!
    autocmd FileType gitcommit setlocal expandtab
    autocmd FileType gitcommit setlocal nolist
    autocmd FileType gitcommit setlocal shiftwidth=8
    autocmd FileType gitcommit setlocal softtabstop=8
augroup END

augroup ag_help
    autocmd!
    autocmd FileType help setlocal nolist
augroup END

augroup ag_html
    autocmd!
    autocmd FileType html setlocal expandtab
    autocmd FileType html setlocal shiftwidth=2
    autocmd FileType html setlocal softtabstop=2
    autocmd FileType html setlocal omnifunc=htmlcomplete#Complete
augroup END

augroup ag_jade
    autocmd!
    autocmd FileType jade setlocal expandtab
    autocmd FileType jade setlocal shiftwidth=2
    autocmd FileType jade setlocal softtabstop=2
augroup END

augroup ag_javascript
    autocmd!
    autocmd FileType javascript setlocal expandtab
    autocmd FileType javascript setlocal shiftwidth=2
    autocmd FileType javascript setlocal softtabstop=2
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#Complete
augroup END

augroup ag_markdown
    autocmd!
augroup END

augroup ag_nerdtree
    autocmd!
    autocmd FileType nerdtree setlocal nolist
    if (&relativenumber == 1)
        autocmd FileType nerdtree setlocal nonumber
    else
       autocmd FileType nerdtree setlocal norelativenumber
    endif
augroup END

augroup ag_notes
    autocmd!
augroup END

augroup ag_pry
    autocmd!
    autocmd BufRead,BufNewFile .pryrc setlocal filetype=ruby
augroup END

augroup ag_pro_c
    autocmd!
    autocmd BufNewFile,BufRead *.pc setlocal filetype=c
    autocmd FileType c setlocal noexpandtab
    autocmd FileType c setlocal nolist
    autocmd FileType c setlocal shiftwidth=8
    autocmd FileType c setlocal softtabstop=0
augroup END

augroup ag_ruby
    autocmd!
    autocmd FileType ruby setlocal expandtab
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END

augroup ag_sh
    autocmd!
    autocmd FileType sh setlocal expandtab
    autocmd FileType sh setlocal shiftwidth=4
    autocmd FileType sh setlocal softtabstop=4
augroup END

augroup ag_scss
    autocmd!
    autocmd FileType scss setlocal expandtab
    autocmd FileType scss setlocal shiftwidth=2
    autocmd FileType scss setlocal softtabstop=2
    autocmd FileType scss setlocal omnifunc=csscomplete#Complete
    autocmd FileType scss setlocal iskeyword+=-
augroup END

augroup ag_simplecov
    autocmd!
    autocmd BufRead,BufNewFile .simplecov setlocal filetype=ruby
augroup END

augroup ag_sql
    autocmd!
    autocmd FileType sql setlocal expandtab
    autocmd FileType sql setlocal shiftwidth=2
    autocmd FileType sql setlocal softtabstop=2
    autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
augroup END

augroup ag_text
    autocmd!
    autocmd FileType text setlocal expandtab
    autocmd FileType text setlocal shiftwidth=4
    autocmd FileType text setlocal softtabstop=4
    autocmd FileType text setlocal spell
augroup END

augroup ag_vim
    autocmd!
    autocmd FileType vim setlocal expandtab
    autocmd FileType vim setlocal shiftwidth=4
    autocmd FileType vim setlocal softtabstop=4
augroup END

augroup ag_xml
    autocmd!
    autocmd FileType xml setlocal expandtab
    autocmd FileType xml setlocal shiftwidth=2
    autocmd FileType xml setlocal softtabstop=2
    autocmd FileType xml setlocal omnifunc=xmlcomplete#Complete
augroup END

augroup ag_yaml
    autocmd!
    autocmd FileType yaml setlocal expandtab
    autocmd FileType yaml setlocal shiftwidth=2
    autocmd FileType yaml setlocal softtabstop=2
augroup END


" PLUGIN SETTINGS
" =============================================================


" NERD_commenter settings.
let NERDCommentWholeLinesInVMode=2
let NERDCreateDefaultMappings=0
let NERDSpaceDelims=1
let NERD_scss_alt_style=1
nmap <Leader>c <Plug>NERDCommenterToggle<C-l>
vmap <Leader>c <Plug>NERDCommenterToggle<C-l>
nmap <Leader>x <Plug>NERDCommenterSexy<C-l>
vmap <Leader>x <Plug>NERDCommenterSexy<C-l>
nmap <Leader>i <Plug>NERDCommenterAltDelims<C-l>

" NERD_tree settings.
let NERDChristmasTree=1
let NERDTreeDirArrows= has("multi_byte") ? 1 : 0
let NERDTreeQuitOnOpen=1
let NERDTreeWinSize=50
nnoremap <Leader>n :NERDTreeToggle<CR>

" gnupg settings.
let g:GPGExecutable="gpg"
let g:GPGPreferArmor=1

" snipMate settings.
let g:snippets_dir=$HOME.'/.vim/snippets'
nnoremap <Leader>es :execute 'split' $HOME . '/.vim/snippets/' . &filetype . '.snippets'<CR>
nnoremap <Leader>rs :call ReloadAllSnippets()<CR><C-L>

" Powerline settings.
if has("multi_byte")
    let g:Powerline_symbols="unicode"
endif

" tabular settings.
nmap <Leader>a, :Tabularize /^[^,]*,\zs /l0l0l0<CR>
nmap <Leader>a- :Tabularize /-<CR>
nmap <Leader>a: :Tabularize /^[^:]*:\zs /l0l0l0<CR>
nmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>as :Tabularize / <CR>
nmap <Leader>a{ :Tabularize /{<CR>
vmap <Leader>a, :Tabularize /^[^,]*,\zs /l0l0l0<CR>
vmap <Leader>a- :Tabularize /-<CR>
vmap <Leader>a: :Tabularize /^[^:]*:\zs /l0l0l0<CR>
vmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>as :Tabularize / <CR>
vmap <Leader>a{ :Tabularize /{<CR>

" fugitive settings.
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gp :Git up<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>

" surround settings.
let g:surround_105  = "#{ \r }" " 105 = ASCII mapping for 'i'

" ctrlp settings.
let g:ctrlp_arg_map = 1
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn|\.swp$\|node_modules\|tmp'
let g:ctrlp_extensions = ['buffertag', 'tag', 'mixed']
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
nnoremap <C-o> :CtrlPTag<CR>

" Buffergator settings.
let g:buffergator_suppress_keymaps = 1
nmap <Leader>b :BuffergatorToggle<CR>

" Git Gutter settings.
let g:gitgutter_enabled = 0
nmap <Leader>gg :GitGutterToggle<CR>
highlight clear SignColumn

" pandoc setting
au BufNewFile,BufRead *.txt   set filetype=pandoc

"Setup some number stuff...
"
"function for switching between number and relativenumber
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

" Auto switch number based on events
:au FocusLost * :set number
:au FocusGained * :set relativenumber

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Needed to make eclime work
let g:EclimCompletionMethod = 'omnifunc'

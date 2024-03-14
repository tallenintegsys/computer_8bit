set nocompatible " get out of horrible vi-compatible mode syntax on " syntax highlighting on
set nowrap " do not wrap line
set bs=2 " allow backspacing over everything in insert mode
set history=1000 " How many lines of history to remember
set fileformats=unix,dos,mac " support all three, in this order
set viminfo+=! " make sure it can save viminfo
set iskeyword+=_,$,@,%,# " none of these should be word dividers, so make them not be
set nostartofline " leave my cursor where it was
set listchars=tab:->,trail:- " show tabs and trailing whitespace
set showmatch " show matching brackets
set matchtime=5 " how many tenths of a second to blink matching brackets for
set hlsearch
set expandtab " no real tabs please!
set softtabstop=4 " unify
set tabstop=4 " real tabs should be 4, but they will show with set list on
"set backup " make backup file
set backupdir=. " where to put backup file
set ruler " Always show current positions along the bottom
set makeef=error.err " When using make, where should it dump the file
set showcmd " show the command being typed
"set clipboard+=unnamed
"clipboard default is fine in terminal VIM, see .gvimrc
"set directory=. " directory is the directory for temp file
"set sessionoptions+=globals " What should be saved during sessions being saved
"set sessionoptions+=localoptions " What should be saved during sessions being saved
"set sessionoptions+=resize " What should be saved during sessions being saved
"set sessionoptions+=winpos " What should be saved during sessions being saved
"set popt+=syntax:y " Syntax when printing
"set popt+=paper:letter " Print on Letter
set linespace=0 " space it out a little more (easier to read)
set wildmenu " turn on wild menu
set wildmode=list:longest " turn on wild menu in special format (long format)
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.swp,*.jpg,*.gif,*.png "ignore some formats
set cmdheight=1 " the command bar is 1 high
"set number " turn on line numbers
"set numberwidth=4 " If we have over 9999 lines, ohh, boo-hoo
set lazyredraw " do not redraw while running macros (much faster) (LazyRedraw)
set hidden " you can change buffer without saving
set backspace=2 " make backspace work normal
"set whichwrap+=<,>,[,],h,l  " backspace and cursor keys wrap to
"set mouse=a " use mouse everywhere
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
set noerrorbells " don't make noise
"set list " we do what to show tabs, to ensure we get them out of my files
"set nohlsearch " do not highlight searched for phrases
set incsearch " BUT do highlight as you type you search phrase
set scroll=1
set scrolloff=5 " Keep 5 lines (top/bottom) for scope
set sidescroll=1
set sidescrolloff=1 " lines at the side
set novisualbell " don't blink
" statusline demo: ~\myfile[+] [FORMAT=format] [TYPE=type] [ASCII=000] [HEX=00] [POS=0000,0000][00%] [LEN=000]
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ "[HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 " always show the status line
set noautoindent
set nosmartindent " smartindent (filetype indenting instead)
"set autoindent " autoindent (should be overwrote by cindent or filetype indent)
"set cindent " do c-style indenting
set shiftwidth=4 " unify
set nocopyindent
"set copyindent " but above all -- follow the conventions laid before us
"filetype plugin indent on " load filetype plugins and indent settings
set formatoptions=q " See Help (complex)
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
set preserveindent " but above all -- follow the conventions laid before us
set ignorecase " case insensitive by default
set smartcase " if there are caps, go case-sensitive
"set completeopt=menu,longest,preview " improve the way autocomplete works
"set cursorcolumn " show the current column
"set foldenable " Turn on folding
"set foldmarker={,} " Fold C style code (only use this as default if you use a
"high foldlevel)
"set foldcolumn=1 " Give 1 column for fold markers
"set foldmethod=marker " Fold on the marker
"set foldlevel=100 " Don't autofold anything (but I can still fold manually)
"set foldopen-=search " don't open folds when you search into them
"set foldopen-=undo " don't open folds when you undo stuff
"function MyFoldText()
"    return getline(v:foldstart).' '
"endfunction
"set foldtext=MyFoldText() " Custom fold text

"function! StartModule()
""    set ft=verilog_systemverilog
"    runtime common/newverilog.vim
"    "endfunction
"
autocmd BufNewFile,BufRead *.v,*.sv,*.svh,*.vs set syntax=systemverilog
"    "autocmd! BufRead *.v,*.vh,*.sv,*.pv,*.module,*.tsbvlib set
"    ft=verilog_systemverilog
"    "autocmd! BufNewFile *.v,*.vh,*.sv,*.pv,*.module,*.tsbvlib call
"    StartModule()
"    "autocmd! BufNewFile *.vhd,*.pvhd,*.vhdl runtime common/newvhdl.vim
"    "autocmd! BufNewFile *.py runtime common/newpython.vim
"    "autocmd! BufNewFile *.c,*.h runtime common/newc.vim

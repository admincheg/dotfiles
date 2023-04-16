syntax on

"{{{ Settings
set autoindent
set backspace=indent,eol,start
set completeopt=longest,menu,preview
set cursorline
set noexpandtab
set foldlevel=0
set foldmethod=marker
set history=1000
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set listchars=tab:>-,trail:•
set mouse=
set nocompatible
set number
set pastetoggle=<F11>
set ruler
set relativenumber
set shiftround
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
set softtabstop=4
set spelllang=en_us,ru,lv
set splitright splitbelow
set synmaxcol=1000
set t_Co=256
set tabstop=4
set wildmode=longest,list
set wrap

set cc=80
"}}}

filetype plugin indent on

"{{{ Plugins
call plug#begin()
Plug 'shougo/deoplete.nvim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-bundler'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'slim-template/vim-slim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'
Plug 'wolfgangmehner/lua-support'
Plug 'ervandew/supertab'
Plug 'sheerun/vim-polyglot'
Plug 'ashfinal/vim-colors-paper'
call plug#end()
"}}}

" {{{ Airline
set laststatus=2
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ' ﲐ'
" }}}

" {{{ Syntastuc
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_signs=1
let g:synastic_quiet_warnings=1
" }}}

" {{{ NERDTree
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeWinPos = "left"
let g:NERDTreeMinimalUI=1
let g:NERDTreeMinimalMenu=1
let g:NERTreeHighlightCursorLine=1
" }}}

" {{{ Tagbar
let g:tagbar_iconchars = ['', '']
" }}}

" {{{ Bindings
let mapleader = ','

vmap <Leader>t\| :'<.'>Tab/\|<cr>
nmap <F1> :NERDTreeToggle<cr>
nmap <F2> :TagbarToggle<cr>
nmap <TAB> <C-w>w
nmap <S-TAB> <C-w>W

map <F10> :set paste<cr>
map <F11> :set nopaste<cr>
imap <F10> <C-O>:set paste<cr>
imap <F11> <nop>
nmap <Leader>l :diffget LO
nmap <Leader>r :diffget RE
" }}}

"{{{ Colors
colorscheme paper
set background=dark
"hi Normal ctermfg=40
"hi Folded ctermbg=236
"hi Search ctermbg=28 ctermfg=195
"hi ColorColumn ctermbg=22
"hi CursorLine cterm=none ctermbg=237
"hi SpellBad ctermbg=124 ctermfg=255
"hi! link MatchParen Constant
"}}}

" {{{ Autocmd
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()
" }}}

" {{{ Functions
function! TrimWhiteSpace()
  if !&binary && &filetype != 'diff'
    normal mz
    %s/\s\+$//e
    normal `z
  endif
endfunction
" }}}

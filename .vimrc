" Use new features
set nocompatible

if filereadable("~/.vim/google.vim")
  source ~/.vim/google.vim
endif

" Basic essentials.
syntax on

" Use local indentation scripts to auto-indent based on file type.
filetype plugin indent on
set autoindent

" Indent/dedent with TAB.
inoremap <S-tab> <C-D>
nnoremap <tab> >>
nnoremap <S-tab> <<
vnoremap <tab> >
vnoremap <S-tab> <

" Set up the colours for selection and the context menu.
highlight Pmenu ctermfg=7 ctermbg=8
highlight PmenuSel ctermfg=11 ctermbg=8
highlight Visual ctermbg=8

" Use Latex.
let g:tex_flavor="latex"

" Change <leader> to ,
let mapleader=","

" Highlight lines longer than 80 characters.
match Error /\%81v.\+/

" Jump to the next/previous grep match or error.
nnoremap < :cp<cr>
nnoremap > :cn<cr>

" Tab settings.
nnoremap <C-t> :tabnew<cr>
nnoremap <C-n> :tabNext<cr>
nnoremap <C-p> :tabPrev<cr>

" Split a line of comma-separated values onto multiple lines.
nnoremap <leader>, :s/,/,\r/g<cr>

" Switch between .cc and .h files with ",.".
nnoremap <leader>. :FSHere<cr>

" Search options.
set incsearch
set hlsearch

" Ignore the case when searching with a lowercase-only search.
" Becomes case sensitive if an uppercase character is used.
set ignorecase
set smartcase

" Clear search highlighting with ",<space>".
nnoremap <leader><space> :noh<cr>

" In normal mode, make j and k navigate by displayed lines rather than actual
" lines.
nnoremap j gj
nnoremap k gk

" Enable deletion of indentation, newlines, and over the start of an insert.
set backspace=indent,eol,start

" Highlight the line containing the cursor.
set cursorline

" Miscellaneous
set encoding=utf-8

" Convert tabs to exactly two spaces (and show actual tabs as 2 spaces).
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" q - Allow formatting of comments with gq.
" 1 - Don't break a line after a one-letter word. Break before it instead.
set formatoptions=q1
set textwidth=80

" Set the options for :grep.
set grepprg=grep\ -nH\ $*

" Allow hidden (closed) buffers to stay open in the background (ie. unsaved
" changes will still be there if the buffer is reopened without having exited).
set hidden

" Always show a status line (contains the filename etc.).
set laststatus=2

" Show the line number and column in the status bar.
set ruler

" Disable VIM modelines (vim settings in file comments).
set modelines=0

" Show relative line numbers, but show the current line number on the current
" line.
set number
set relativenumber

" Automatically scroll when the cursor is within 5 lines of the edge of the
" screen, if possible.
set scrolloff=5

" Show commands as they are typed.
set showcmd

" Display the current mode in the bottom line.
set showmode

" Briefly highlight matching brackets when the cursor passes over them.
set showmatch

" Make VIM use fast redrawing techniques.
set ttyfast

" Enable enhanced command-line completion.
set wildmenu
set wildmode=list:longest

" Enable text wrapping (doesn't change the file).
set wrap

colorscheme monokai

" Add magic for sudo save
cmap w!! w !sudo tee > /dev/null %
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 85e15e6095cfce167422e5edb8466966 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/home/samuel/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line

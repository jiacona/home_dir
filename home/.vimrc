" ----------------------------------------------------------
" Vundle setup
" ----------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'jpalardy/vim-slime'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab autoindent
set background=dark
set incsearch
set ignorecase smartcase
set number
set laststatus=2

colorscheme solarized

let g:Powerline_symbols = 'fancy'

" ----------------------------------------------------------
" ctrlp customization
" ----------------------------------------------------------

" don't search vim tmp files
let g:ctrlp_custom_ignore = '\.gz\|\.jpg\|\.swp\|\.png'
" set wildignore+=*.jpg,*.gz

" don't search dotfiles/dirs
let g:ctrlp_dotfiles = 0

" ----------------------------------------------------------
" auto remove trailing whitespace from certain filetypes
" ----------------------------------------------------------
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

autocmd FileType c,cpp,java,php,ruby,python,puppet,json,yaml autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" ----------------------------------------------------------
" Pretty print JSON
" ----------------------------------------------------------
map <leader>jt <Esc>:%!json_xs -f json -t json-pretty<CR>

" ----------------------------------------------------------
" Ruby supertab
" ----------------------------------------------------------
"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" ----------------------------------------------------------
" Line comment/uncomment
" ----------------------------------------------------------
map ,i :s/^/\/\/ /<CR>
map ,u :s/^\/\/ //<CR>

" ----------------------------------------------------------
" Window resizing mappping
" ----------------------------------------------------------
" window resizing mappings (functions.vim plugin)/*{{{*/
nnoremap <silent> <S-Up> :normal <c-r>=Resize('+')<cr><cr>
nnoremap <silent> <S-Down> :normal <c-r>=Resize('-')<cr><cr>
nnoremap <silent> <S-Left> :normal <c-r>=Resize('<')<cr><cr>
nnoremap <silent> <S-Right> :normal <c-r>=Resize('>')<cr><cr>

    fun! Resize(dir)
let this = winnr()

    if '+' == a:dir || '-' == a:dir
    execute "normal <c-w>k"
let up = winnr()
    if up != this
    execute "normal <c-w>j"
    let x = 'bottom'
    else
    let x = 'top'
    endif
    elseif '>' == a:dir || '<' == a:dir
    execute "normal <c-w>h"
let left = winnr()
    if left != this
    execute "normal <c-w>l"
    let x = 'right'
    else
    let x = 'left'
    endif
    endif

    if ('+' == a:dir && 'bottom' == x) || ('-' == a:dir && 'top' == x)
    return "5\<c-v>\<c-w>+"
    elseif ('-' == a:dir && 'bottom' == x) || ('+' == a:dir && 'top' == x)
    return "5\<c-v>\<c-w>-"
    elseif ('<' == a:dir && 'left' == x) || ('>' == a:dir && 'right' == x)
    return "5\<c-v>\<c-w><"
    elseif ('>' == a:dir && 'left' == x) || ('<' == a:dir && 'right' == x)
    return "5\<c-v>\<c-w>>"
    else
    echo "oops. check your ~/.vimrc"
    return ""
    endif
    endfun

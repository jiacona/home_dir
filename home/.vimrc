" Pathogen
execute pathogen#infect()
execute pathogen#helptags()

syntax on
filetype plugin indent on

" Colorscheme
set background=dark
colorscheme solarized

" Ensure that the line-number background is transparent
hi clear LineNr

" Ensure that the sign-column background is transparent
hi clear SignColumn
"
" Highlighting rule to catch leading/trainling whitespace
au BufRead,BufNew,BufNewFile * syn match ExtraSpace /^\s\+\|\s\+$/

" Right rule
set colorcolumn=88

" General
set backspace=eol,indent,start
set cursorline
set encoding=utf-8
set incsearch
set laststatus=2
set nobackup
set nocompatible
set nohls
set notitle
set number
set scrolloff=3
set showmatch
set showtabline=2
set ignorecase smartcase
set ttyfast
set lazyredraw
set visualbell
set wildmode=list:longest
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

let loaded_matchparen = 1
let mapleader = ','

" Use spaces instead of TABs
set shiftwidth=2
set tabstop=2
set expandtab

" Set indentation rules for java (and files with tabs)
set listchars=tab:»\ ,eol:¬
highlight NonText term=NONE cterm=NONE ctermfg=0
highlight SpecialKey term=NONE cterm=NONE ctermbg=NONE ctermfg=0

autocmd Filetype java setlocal noexpandtab
function! ToggleTabMode()
  let expand = &expandtab
  if expand
    set noexpandtab
    set list
  else
    set expandtab
    set nolist
  end
endfunction
noremap <F5> :call ToggleTabMode()<CR>

" GUI specific ({g,Mac}Vim)
if has('gui_running')
  set guifont=Monaco:h12
  set guioptions-=r
endif

let g:slime_target = "tmux"

" Toggle Highlight-Whitespace Helper
function! ToggleHighlightWhitespace()
  if !exists('g:highlight_whitespace')
    let g:highlight_whitespace=0
  end
  if g:highlight_whitespace
    hi clear ExtraSpace
    let g:highlight_whitespace=0
  else
    hi ExtraSpace ctermbg=1 guibg=red
    let g:highlight_whitespace=1
  endif
  redraw!
endfunction
noremap <F4> :call ToggleHighlightWhitespace()<CR>

" Toggle Paste-Mode Helper
function! TogglePasteMode()
  set paste!
  redraw!
endfunction
noremap <F2> :call TogglePasteMode()<CR>

" Silver Searcher / CtrlP
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_working_path_mode = 'rw'
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --ignore\ tags
  let g:ctrlp_user_command='ag %s -l --nocolor -i -g ""'
  let g:ctrlp_use_caching=1
endif
" Sane Ignore For ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp\|\vendor\/java$|target/',
  \ 'file': '\.exe$\|\.so$\|\.dat$'
  \ }

" Find in Files
command! -nargs=+ -complete=file -bar FindInFiles silent! grep! <args>|cwindow|redraw!
noremap <F3> :FindInFiles<SPACE>
" Find All References
noremap <C-K> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>

" Toggle the Location and Quickfix windows
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction
function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction
nnoremap <silent> <Leader>q :call ToggleList("Quickfix List", 'c')<CR>

" Rspec.vim mappings
let g:rspec_command = "!(bash -l -c 'rspec {spec}')"
noremap <Leader>s :call RunCurrentSpecFile()<CR>
noremap <Leader>l :call RunLastSpec()<CR>
noremap <Leader>a :call RunAllSpecs()<CR>

" Lightline
function! CurrentFilename()
  return ('' != expand('%:p') ? substitute(expand('%:p'), expand('$HOME'), '~', 'g') : '[No Name]')
endfunction
let g:lightline = {
      \ 'colorscheme': 'solarized_dark',
      \ 'active': {
      \   'left': [
      \      ['mode', 'paste'],
      \      ['fugitive', 'readonly', 'filename', 'modified']
      \   ]
      \ },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_function': {
      \   'filename': 'CurrentFilename'
      \ },
      \ 'component_visible_condition': {
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

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

" autocmd! BufWritePre * :call <SID>StripTrailingWhitespaces()
noremap <Leader>ss :call <SID>StripTrailingWhitespaces()<CR>

" ----------------------------------------------------------
" Ruby supertab
" ----------------------------------------------------------
autocmd! FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd! FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd! FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd! FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

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

noremap <leader>ev :split $MYVIMRC<cr>
noremap <leader>ev :split $MYVIMRC<cr>
noremap <leader>sv :source $MYVIMRC<cr>

noremap H ^
noremap L $

" ReIndent current file
function! ReIndentFile()
  normal mzG=gg`z
  w
endfunction
noremap ri :call ReIndentFile()<CR>

" Load ctags for gems
autocmd FileType ruby let &l:tags = pathogen#legacyjoin(pathogen#uniq(
  \ pathogen#split(&tags) +
  \ map(split($GEM_PATH,':'),'v:val."/gems/*/tags"')))

" Associate *.tagx files with xml filetype
au BufRead,BufNewFile *.tagx setfiletype xml

" Toggle word wrap
function! ToggleWordWrap()
  if &tw
    echo "Turning off text wrapping"
    setlocal tw=0
  else
    echo "Turning on text wrapping at col 88"
    setlocal tw=88
  endif
endfunction
noremap <leader>ww :call ToggleWordWrap()<CR>

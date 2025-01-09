colorscheme default
syntax on
set number
set tabstop=4
set shiftwidth=4
set expandtab
set visualbell t_vb=
set autoindent

" visuals for whitespace, toggle with `:set list` and `set nolist`"
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" change cursor between modes"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" tab in visual mode "
vmap <Tab> >gv
vmap <S-Tab> <gv
" shift+. and shift+, for indenting in visual mode
vmap > >gv
vmap < <gv

" insert new line without insert "
nmap nn o<Esc>k

" move to end of line"
map e $

" open at same location file was closed "
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
endif

" Toggle comments with Ctrl+/
" Note: In vim, Ctrl+/ is interpreted as Ctrl+_
vnoremap <C-_> :call ToggleComment()<CR>

" Ctrl+f to search for word when in visual mode
vnoremap <C-f> y/\V<C-R>"<CR>

function! ToggleComment()
    " Get the first line to check if it's commented
    let firstline = getline(line("'<"))
    let isCommented = match(firstline, '^\s*#') >= 0

    if isCommented
        " Uncomment lines
        execute "'<,'>s/^\\s*#\\s\\?//e"
    else
        " Comment lines
        execute "'<,'>s/^\\(\\s*\\)/\\1# /"
    endif
endfunction

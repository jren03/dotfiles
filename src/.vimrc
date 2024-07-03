colorscheme default
syntax on
set number
set tabstop=4
set shiftwidth=4
set expandtab
set visualbell
set autoindent

" visuals for whitespace, toggle with `:set list` and `set nolist`"
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" change cursor between modes"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" tab in visual mode "
vmap <Tab> >gv
vmap <S-Tab> <gv

" insert new line without insert "
nmap nn o<Esc>k

" move to end of line"
map e $

" open at same location file was closed "
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

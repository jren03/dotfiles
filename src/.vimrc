colorscheme default
syntax on
set shiftwidth=4
set tabstop=4
set visualbell
set autoindent

" change cursor between modes"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" insert new line without insert "
nmap nn o<Esc>k

" move to end of line"
map e $

" open at same location file was closed "
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

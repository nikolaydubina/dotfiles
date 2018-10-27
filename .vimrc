set backspace=2
set t_Co=256
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline-Powerline.otf
set laststatus=2
" -------------------------------------------

set shiftwidth=4 softtabstop=4
set expandtab
set textwidth=120
set tabstop=4
set hlsearch
set autoindent
set nu                                  " no | nonu
set noautoread                          " tells vim not to automatically reload changed files
set ic                                  " Case insensitive search
set hls                                 " Higlhight search
set lbr                                 " Wrap text instead of being on one line

set splitbelow                          " natural split
set splitright                          " natural vsplit

xnoremap p pgvy                         " paste multiple times after yank

colorscheme pablo                       " koehler | pablo | morning
syntax on
autocmd FileType make set noexpandtab
filetype plugin indent on               " Indent automatically depending on filetype
map <Leader>]' :nohl<CR>                " fast unhiglhight

" DiffWithSaved ------------------------------
function! DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

" sets up mappings to function
com! DiffSaved call DiffWithSaved()
map <Leader>ds :DiffSaved<CR>
" --------------------------------------------

" for pasting --------------------------------
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
" --------------------------------------------

" Log ----------------------------------------
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo
" --------------------------------------------

" cursor restore position --------------------
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END
" --------------------------------------------

" python -------------------------------------
" http://stackoverflow.com/a/360634/596459
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf
set foldnestmax=6
set foldlevelstart=20
nmap <F6> /}<CR>zf%<ESC>:nohlsearch<CR>
" --------------------------------------------

" some color tweaks -------------------------------
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

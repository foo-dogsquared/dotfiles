" plugin list (using vim-plug)
call plug#begin('~/.vim/plugged')

Plug 'sirver/ultisnips'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug '907th/vim-auto-save'

Plug 'vim-airline/vim-airline'
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" enable auto-save on startup
let g:auto_save = 1

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

Plug 'airblade/vim-gitgutter'

call plug#end()

" quick escape to default mode
inoremap jk <Esc>

" editor configurations
" setting number lines in the gutter
set number relativenumber

" set tab to enter 4 spaces, instead
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

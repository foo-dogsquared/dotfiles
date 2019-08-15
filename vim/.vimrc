" plugin list (using vim-plug)
call plug#begin('~/.vim/plugged')

Plug 'sirver/ultisnips'
" setting my private snippets in a consistent home directory
let g:UltiSnipsSnippetDirectories = [$HOME . "/.vim/own-snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plug 'scrooloose/nerdtree'

Plug 'honza/vim-snippets'

Plug '907th/vim-auto-save'
let g:auto_save = 1

Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_compiler_latexmk = {
    \ 'options': [
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \ ]
\}

Plug 'airblade/vim-gitgutter'

call plug#end()

" quick escape to default mode
inoremap jk <Esc>

" editor configurations
" setting number lines in the gutter
set number relativenumber

" setting line highlighting based on the position of the cursor
set cursorline

" set tab to enter spaces, instead
set expandtab

let template_list = [
\    ["_minted-", ""],
\    ["", ".synctex"],
\]

function VimtexAdditionalCleanup(template_list)
    let file_name = expand("%:t:r")
    let file_path = expand("%:p:h") . "/"
    for template in a:template_list
        let prefix = template[0]
        let suffix = template[1]
        let full_template_path = file_path . prefix . file_name . suffix
        call delete(full_template_path, "rf")
    endfor
endfunction

" initiate LaTeX file compilation at the start and auto clean up
augroup vimtex_events
    au!
    " auto-clean
    au User VimtexEventQuit     call vimtex#compiler#clean(1)
    au User VimtexEventQuit     call VimtexAdditionalCleanup(template_list)
    
    " auto-compile
    au User VimtexEventInitPost call vimtex#compiler#compile()
augroup END

" open nerd-tree at the start of each file opening
autocmd vimenter * NERDTree

" spell checker (for your local language, anyway)
setlocal spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" changing style of words
hi clear SpellBad
hi SpellBad cterm=bold,underline ctermfg=red

hi clear SpellLocal
hi SpellLocal cterm=bold,underline ctermfg=cyan


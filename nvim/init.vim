" Plugin list (using vim-plug).
" Activate it with ':PlugInstall' for the first time.
call plug#begin('~/.config/nvim/plugged')

Plug 'sirver/ultisnips'
" Setting my private snippets in a consistent home directory
let g:UltiSnipsSnippetDirectories = [$HOME . "/.config/nvim/own-snippets", "own-snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="context"

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

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
    \   '-bibtex',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \ ]
\}

let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-lualatex',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
\}

Plug 'airblade/vim-gitgutter'

call plug#end()


" Quick escape to default mode.
inoremap jk <Esc>

" Editor configurations:
" Setting number lines in the gutter.
set number relativenumber

" Setting line highlighting based on the position of the cursor.
set cursorline

" Set tab to enter spaces, instead.
set expandtab

" Set entering tab to 4 spaces.
set shiftwidth=4 tabstop=4

" The template list is simply an array composed of vector that represents the
" prefix and the suffix of the template file name.
let template_list = [
\    ["_minted-", ""],
\    ["", ".synctex"],
\]

function VimtexAdditionalCleanup(template_list)
    call vimtex#compiler#clean(1)
    let file_name = expand("%:t:r")
    let file_path = expand("%:p:h") . "/"
    for template in a:template_list
        let prefix = template[0]
        let suffix = template[1]
        let full_template_path = file_path . prefix . file_name . suffix
        call delete(full_template_path, "rf")
    endfor
endfunction

" Initiate LaTeX file compilation at the start and auto clean up.
augroup vimtex_events
    au!
    " auto-clean
    au User QuitPre             call VimtexAdditionalCleanup(template_list)
    au User VimLeave             call VimtexAdditionalCleanup(template_list)
    au User VimtexEventQuit     call vimtex#compiler#clean(1)
    au User VimtexEventQuit     call VimtexAdditionalCleanup(template_list)

    " Auto-compile
    au User VimtexEventInitPost call vimtex#compiler#compile()
augroup END

" Open nerd-tree at the start of each file opening.
autocmd vimenter * NERDTree

" Set list and other listing characters (:h listchars).
set list listchars=tab:→\ ,trail:·

" Show leading spaces.
" SOURCE: https://www.reddit.com/r/vim/comments/5fxsfy/show_leading_spaces/
hi Conceal guibg=NONE ctermbg=NONE ctermfg=DarkGrey
autocmd BufWinEnter * setl conceallevel=1
autocmd BufWinEnter * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·
autocmd BufReadPre * setl conceallevel=1
autocmd BufReadPre * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·

" Enabling spell checker (for your local language, anyway).
setlocal spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Changing style of words.
hi clear SpellBad
hi SpellBad cterm=bold,underline ctermfg=red

hi clear SpellLocal
hi SpellLocal cterm=bold,underline ctermfg=cyan


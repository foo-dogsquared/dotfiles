"""""""""""
" PLUGINS "
"""""""""""

" This configuration uses vim-plug (https://github.com/junegunn/vim-plug) as
" the plugin manager.
" Activate it with ':PlugInstall' for the first time (and when adding new plugins).
" And run ':PlugUpgrade' for upgrading the plugins.
call plug#begin('~/.config/nvim/plugged')

" Nord color scheme
Plug 'arcticicestudio/nord-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'chriskempson/base16-vim'

" EditorConfig plugin
Plug 'editorconfig/editorconfig-vim'

" Colorize common color strings
Plug 'lilydjwg/colorizer'

" A snippets engine.
" One of the must-haves for me.
Plug 'sirver/ultisnips'

" Setting my private snippets in a consistent home directory and a relative snippets directory for project-specific snippets.
let g:UltiSnipsSnippetDirectories = [$HOME . "/.config/nvim/own-snippets", ".snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="context"

" Contains various snippets for UltiSnips.
Plug 'honza/vim-snippets'

" A completion engine.
" I chose this engine since it is linked from UltiSnips.
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1

" One of the most popular plugins.
" Allows to create more substantial status bars.
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Emmet is an HTML plugin for easy HTML writing
Plug 'mattn/emmet-vim'

" A full LaTeX toolchain plugin for Vim.
" Also a must-have for me since writing LaTeX can be a PITA.
" Most of the snippets and workflow is inspired from Gilles Castel's posts (at https://castel.dev/).
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

" I use LuaLaTeX for my documents so let me have it as the default, please?
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

" Enable visuals for addition/deletion of lines in the gutter (side) similar to Visual Studio Code.
Plug 'airblade/vim-gitgutter'

" Plugin for distraction-free writing.
Plug 'junegunn/goyo.vim'

" A Nix plugin.
Plug 'LnL7/vim-nix'
call plug#end()




"""""""""""""""""""""""""
" EDITOR CONFIGURATIONS "
"""""""""""""""""""""""""
set encoding=utf-8

let mapleader=" "

colorscheme nord

" Setting number lines in the gutter.
set number relativenumber
highlight CursorLineNr ctermfg=cyan
highlight Visual term=reverse cterm=reverse

" Setting line highlighting based on the position of the cursor.
set cursorline

" Set tab to enter spaces, instead.
set expandtab

" Set entering tab to 4 spaces.
set shiftwidth=4 tabstop=4

" Set list and other listing characters (:h listchars).
set list listchars=tab:→\ ,trail:·

" Enabling spell checker (for your local language, anyway).
setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Quick escape to default mode.
inoremap jk <Esc>

" Instant Goyo toggle.
map <leader>w :Goyo<Enter>

" Trim all trailing whitespaces.
map <leader>s :%s/\s\+$/<Enter>

" Reload $MYVIMRC.
map <leader>hr :source $MYVIMRC<Enter>

" File explorer toggle.
" Turns out vim (and nvim) has a native file explorer with :Explore.
map <leader>ff :Lexplore<Return>:vertical resize 40<Return><C-w><C-w>

" Changing style of words.
highlight clear SpellBad

highlight clear SpellLocal

highlight clear SpellCap

highlight clear SpellRare




""""""""""
" EVENTS "
""""""""""

" Show leading spaces.
" SOURCE: https://www.reddit.com/r/vim/comments/5fxsfy/show_leading_spaces/
hi Conceal guibg=NONE ctermbg=NONE ctermfg=DarkGrey
autocmd BufWinEnter * setl conceallevel=1
autocmd BufWinEnter * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·
autocmd BufReadPre * setl conceallevel=1
autocmd BufReadPre * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·

" The template list is simply an array composed of vector that represents the
" prefix and the suffix of the template file name.
let template_list = [
\    ["_minted-", ""],
\    ["", ".synctex"],
\]

" Additional LaTeX files cleanup.
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

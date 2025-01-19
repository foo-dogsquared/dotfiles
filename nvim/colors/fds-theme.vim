" You probably always want to set this in your vim file
set background=dark
let g:colors_name="fds-theme"

" include our theme file and pass it to lush to apply
lua require('lush')(require('lush_theme.fds-theme'))

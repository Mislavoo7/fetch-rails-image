" Title:        Fetch rails image
" Description:  VIM plugin to add an missing image.
" Last Change:  2025-07-29
" Maintainer:   Mislav Kvesic <https://github.com/Mislavoo7>

if exists("g:loaded_fetch_rails_image")
  finish
endif
let g:loaded_fetch_rails_image = 1

command! -nargs=0 FetchRailsImage call fetch_rails_image#run_fetch_rails_image()

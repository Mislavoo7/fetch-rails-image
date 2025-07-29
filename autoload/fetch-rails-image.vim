function! fetch_rails_image#run_fetch_rails_image() abort
  let rails_root = s:FindRailsRoot()
  let results = []
  if rails_root == ''
    echo 'Not in a Rails project'
    return
  endif

  let line = getline('.')
  let cursor_col = col('.') - 1 " Convert to 0-based index

  " Match image_tag 'icons/foo.png' or "icons/foo.png"
  let pattern = '<%= *image_tag *[\'"]\zs[^\'"]\+\ze[\'"]'

  " Check if cursor is on the matched text
  let match_pos = matchstrpos(line, pattern)
  if match_pos == ['', -1, -1]
    echo 'No image_tag found on this line'
    return
  endif

  let [matched_text, start_col, end_col] = match_pos
  if cursor_col < start_col || cursor_col > end_col
    echo 'Cursor not on image_tag path'
    return
  endif

  " Construct full path to the image file
  let image_path = matched_text
  let image_file = rails_root . '/app/assets/images/' . image_path

  " Try checking for the image file or with typical extensions
  if filereadable(image_file)
    echo 'The image is present: ' . image_path
  else
    " Try common Rails image extensions if not present
    let extensions = ['.png', '.jpg', '.jpeg', '.svg', '.gif']
    let found = 0
    for ext in extensions
      if filereadable(image_file . ext)
        echo 'The image is present (with extension): ' . image_path . ext
        let found = 1
        break
      endif
    endfor

    if !found
      echo 'No image under this path: ' . image_path
    endif
  endif
endfunction

function! s:FindRailsRoot()
  let current_dir = expand('%:p:h')
  while current_dir != '/'
    if filereadable(current_dir . '/config/application.rb')
      return current_dir
    endif
    let current_dir = fnamemodify(current_dir, ':h')
  endwhile
  return ''
endfunction

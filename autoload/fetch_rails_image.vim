function! fetch_rails_image#run_fetch_rails_image() abort
  let rails_root = s:FindRailsRoot()
  let results = []
  if rails_root == ''
    echo 'Not in a Rails project'
    return
  endif
  let line = getline('.')
  let cursor_col = col('.') - 1 " Convert to 0-based index

  " Match image_tag 'icons/foo.png' 
  let pattern = '\([''"]\)\([^''"]*\/[^''"]*\)\1'

  let match = matchlist(line, pattern)

  if empty(match)
    echo 'No path found in current line'
    return
  endif

  let image_path = match[2]
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

      let filename = fnamemodify(image_path, ':t:r')  " Get filename without path and extension
      let suggested_prompt = substitute(filename, '[_-]', ' ', 'g')  " Replace underscores/hyphens with spaces

      " Ask user what they want to do
      echo "\nWhat would you like to do?"
      echo "1. Create image with prompt: '" . suggested_prompt . "'"
      echo "2. Enter another prompt"
      echo "3. No action"

      let choice = input("Enter your choice (1-3): ")

      if choice == '1'
        call s:CreateImageWithPrompt(image_file, suggested_prompt)
      elseif choice == '2'
        let custom_prompt = input("Enter your prompt: ")
        if custom_prompt != ''
          call s:CreateImageWithPrompt(image_file, custom_prompt)
        else
          echo "No prompt entered, cancelling."
        endif
      elseif choice == '3'
        echo "No action taken."
      else
        echo "Invalid choice, no action taken."
      endif
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

function! s:CreateImageWithPrompt(image_file, prompt) abort
  echo " "
  let cmd = 'tgpt --img --out ' . shellescape(a:image_file) . ' ' . shellescape(a:prompt)
"  echo "Executing command: " . cmd
  
  " Execute the command and capture result
  let result = system(cmd)
  let exit_code = v:shell_error
  
  " Show the result and check for errors
  if exit_code == 0
    if filereadable(a:image_file)
      echo "Image successfully created in: " . a:image_file
    else
      echo "Command completed but image file not found. Check if tgpt created it elsewhere."
      echo "Command output: " . result
    endif
  else
    echo "Error creating image (exit code " . exit_code . "): " . result
  endif
endfunction

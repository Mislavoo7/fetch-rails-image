# Fetch Rails Image

A Vim plugin that detects missing Rails image assets and generates them using AI, preventing those annoying 500 errors during development.

**It will work only if you install [tgpt](https://github.com/aandrew-me/tgpt)!!**

## Demo

![demo2](https://github.com/user-attachments/assets/78a46fcd-b8cc-40a7-9978-a2c0ba6aa51f)


## Installation

### Using vim-plug

Add this to your `.vimrc`:

```vim
Plug 'yourusername/fetch-rails-image'
```

Then run `:PlugInstall`

### Using Vundle

Add to your `.vimrc`:

```vim
Plugin 'yourusername/fetch-rails-image'
```

Then run `:PluginInstall`

### Manual Installation

1. Clone this repository
2. Copy the plugin files to your vim plugin directory (`~/.vim/plugin/`)

## Usage

### Basic Workflow

1. **Position your cursor** on any `image_tag` helper in your Rails view:
   ```erb
   <%= image_tag "hero-banner.png", alt: "Hero Banner" %>
   ```

2. **Execute the plugin** using your configured keybinding. You could add: 
```vim
nnoremap <leader>o :FetchRailsImage<CR>
```
To your .vimrc. 

3. **Handle the result**:
   - **Image exists**: No action needed, continue coding
   - **Image missing**: Choose from three options:

4. **Missing Image Options**

When an image is missing, you'll see:

```
1. Create image with prompt: 'hero banner'
2. Enter another prompt
3. No action
```

   - **Option 1: Auto-prompt Generation** - Uses the filename as a basis for the AI prompt
   - **Option 2: Custom Prompt** - Allows you to enter a custom prompt for more specific image generation
   - **Option 3: No Action** - Exits without making changes


## License

This project is licensed under the MIT License. 

## Acknowledgments

- Built with ❤️ for the Rails community
- Powered by [tgpt](https://github.com/aandrew-me/tgpt)
- Inspired by the need to eliminate those pesky missing asset errors in development

---

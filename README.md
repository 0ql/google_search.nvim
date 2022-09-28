# google_search.nvim

Opens a Dmenu-like prompt built with [nui.nvim](https://github.com/MunifTanjim/nui.nvim) where you can enter your search term it will also give you search recommendation. Requires `curl` and `xdg-open` to work. This is my first neovim plugin so I'm not sure what I'm doing.

## Install 

Packer
```lua
use { "0ql/google_search.nvim", requires = 'MunifTanjim/nui.nvim' }
```

## Usage

Running
```
:GS
```
triggers the prompt.

## Issues

- Due to no proper URL encoding for search recommendations and the search itself special characters are currently not working.
- special chars are also not showing properly in the search recommendations

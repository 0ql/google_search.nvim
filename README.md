# google_search.nvim

Opens a Dmenu-like prompt where you can enter your search term it will also give you search recommendations. Requires `curl` and `xdg-open` to work. This is my first neovim plugin so I'm not sure what I'm doing.

## Usage

Running
```
:lua require("google_search")()
```
triggers the prompt.

## Issues

- Due to no proper URL encoding for search recommendations and the search itself special characters are currently not working.
- special chars are also not showing properly in the search recommendations

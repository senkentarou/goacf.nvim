# goacf.nvim
* Git open all changed files (goacf) plugin for neovim.

![goacf_demo](https://github.com/senkentarou/goacf.nvim/assets/12808787/bd26b48a-ad5c-4118-a3e2-2a265f4a0ade)

## Install
* Plug: `Plug 'senkentarou/goacf.nvim'`

## Usage
* Please execute `:Goacf` command on .git repository, then open all changed files.
* Or set keymap as below,
```
nnoremap <silent> <C-g><C-o> :<C-u>Goacf<CR>
```

## For development
* Load under development plugin files on root repository.

`nvim --cmd "set rtp+=."`

## License
* MIT

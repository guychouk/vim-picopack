# picopack.vim

```vim
let g:picopack = [
  \ 'tpope/vim-fugitive',
  \ 'junegunn/fzf.vim',
\ ]
```

```
:PicopackInstall   - clone missing packages
:PicopackUpdate    - pull latest for all packages
:PicopackClean     - remove unlisted packages
:PicopackUpgrade   - update picopack itself
```

Vim 8 ships with native package loading (`:h packages`) from the `pack/` directory but no way to install or update packages. picopack adds four commands and nothing else.

## Install

Clone into your Vim packages directory:

```sh
git clone https://github.com/guychouk/vim-picopack \
  ~/.vim/pack/picopack/start/vim-picopack
```

## Configuration

Add a `g:picopack` list to your vimrc. Entries are GitHub `user/repo` shorthand or full URLs:

```vim
let g:picopack = [
  \ 'tpope/vim-fugitive',
  \ 'tpope/vim-surround',
  \ 'junegunn/fzf.vim',
  \ 'https://gitlab.com/user/plugin.git',
\ ]
```

Packages are cloned to the first entry in your `packpath` (`:h packpath`) under `pack/bundle/start/` by default. To change this:

```vim
let g:picopack_path = '~/.vim/pack/my-plugins/start'
```

## Commands

- `:PicopackInstall` — shallow-clone any packages not yet on disk
- `:PicopackUpdate` — `git pull --rebase` in every installed package
- `:PicopackClean` — delete directories that aren't in your `g:picopack` list
- `:PicopackUpgrade` — update picopack itself

## See also

- [picoline.vim](https://github.com/guychouk/vim-picoline) — a tiny statusline

## That's it

See `:help picopack` for the full documentation.

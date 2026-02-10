# picopack.vim

```vim
let g:picopack = [
  \ 'tpope/vim-fugitive',
  \ 'junegunn/fzf.vim',
\ ]

let g:picopack_opt = [
  \ 'yegappan/lsp',
\ ]
```

```
:PicopackInstall   - clone missing packages (start + opt)
:PicopackUpdate    - pull latest for all packages (start + opt)
:PicopackClean     - remove unlisted packages (start + opt)
:PicopackUpgrade   - update picopack itself
```

Vim 8 ships with native package loading (`:h packages`) from the `pack/` directory but no way to install or update packages. picopack adds four commands and nothing else. It supports both start packages (loaded at startup) and optional packages (loaded on demand with `:packadd`).

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

For packages you want to load on demand with `:packadd`, use `g:picopack_opt`:

```vim
let g:picopack_opt = [
  \ 'yegappan/lsp',
\ ]
```

Start packages are cloned to `pack/bundle/start/`, opt packages to `pack/bundle/opt/`. Both paths are derived from the first entry in your `packpath` (`:h packpath`). To change the start path (opt is derived automatically):

```vim
let g:picopack_path = '~/.vim/pack/my-plugins/start'
```

## Commands

- `:PicopackInstall` — shallow-clone any packages not yet on disk (start and opt)
- `:PicopackUpdate` — `git pull --rebase` in every installed package (start and opt)
- `:PicopackClean` — delete directories that aren't in `g:picopack` or `g:picopack_opt`
- `:PicopackUpgrade` — update picopack itself

## See also

- [picoline.vim](https://github.com/guychouk/vim-picoline) — a tiny statusline

## That's it

See `:help picopack` for the full documentation.

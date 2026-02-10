" picopack.vim - Minimal package manager for Vim 8+
" Maintainer: guychouk
" License: Same terms as Vim itself (see :h license)

if exists('g:loaded_picopack')
  finish
endif
let g:loaded_picopack = 1

let s:start_path = get(g:, 'picopack_path', split(&packpath, ',')[0] . '/pack/bundle/start')
let s:opt_path = substitute(s:start_path, '/start$', '/opt', '')

function! s:name(repo)
  return substitute(a:repo, '^.*/', '', '')
endfunction

function! s:echo(msg, hl)
  execute 'echohl' a:hl
  echo a:msg
  echohl None
endfunction

function! s:install_to(packages, path)
  if !isdirectory(a:path)
    call mkdir(a:path, 'p')
  endif
  for repo in a:packages
    let name = s:name(repo)
    let dest = a:path . '/' . name
    if !isdirectory(dest)
      call s:echo('Installing ' . name . '...', 'MoreMsg')
      let url = repo =~# '^https\?://' ? repo : 'https://github.com/' . repo
      let out = system('git clone --depth=1 ' . shellescape(url) . ' ' . shellescape(dest))
      if v:shell_error
        call s:echo('Failed: ' . name, 'ErrorMsg')
        echo out
      else
        call s:echo('Installed: ' . name, 'MoreMsg')
      endif
    else
      call s:echo('Already installed: ' . name, 'Comment')
    endif
  endfor
endfunction

function! s:update_in(packages, path)
  for repo in a:packages
    let name = s:name(repo)
    let dest = a:path . '/' . name
    if isdirectory(dest)
      call s:echo('Updating ' . name . '...', 'MoreMsg')
      let out = system('git -C ' . shellescape(dest) . ' pull --rebase')
      if v:shell_error
        call s:echo('Failed: ' . name, 'ErrorMsg')
      else
        echo out
      endif
    endif
  endfor
endfunction

function! s:clean_in(packages, path)
  let installed = glob(a:path . '/*', 0, 1)
  let keep = map(copy(a:packages), 'a:path . "/" . s:name(v:val)')
  for dir in installed
    if index(keep, dir) == -1
      let name = fnamemodify(dir, ':t')
      call s:echo('Removing ' . name . '...', 'WarningMsg')
      call delete(dir, 'rf')
    endif
  endfor
endfunction

function! s:install()
  let start = get(g:, 'picopack', [])
  let opt = get(g:, 'picopack_opt', [])
  if empty(start) && empty(opt)
    call s:echo('Nothing to install. Define packages in g:picopack or g:picopack_opt', 'WarningMsg')
    return
  endif
  call s:install_to(start, s:start_path)
  call s:install_to(opt, s:opt_path)
  call s:echo('Done!', 'MoreMsg')
endfunction

function! s:update()
  let start = get(g:, 'picopack', [])
  let opt = get(g:, 'picopack_opt', [])
  if empty(start) && empty(opt)
    call s:echo('Nothing to update. Define packages in g:picopack or g:picopack_opt', 'WarningMsg')
    return
  endif
  call s:update_in(start, s:start_path)
  call s:update_in(opt, s:opt_path)
  call s:echo('Done!', 'MoreMsg')
endfunction

function! s:clean()
  call s:clean_in(get(g:, 'picopack', []), s:start_path)
  call s:clean_in(get(g:, 'picopack_opt', []), s:opt_path)
  call s:echo('Done!', 'MoreMsg')
endfunction

function! s:upgrade()
  let root = expand('<sfile>:p:h:h')
  call s:echo('Upgrading picopack...', 'MoreMsg')
  let out = system('git -C ' . shellescape(root) . ' pull --rebase')
  if v:shell_error
    call s:echo('Failed to upgrade picopack', 'ErrorMsg')
  else
    echo out
  endif
endfunction

command! PicopackInstall call <SID>install()
command! PicopackUpdate  call <SID>update()
command! PicopackClean   call <SID>clean()
command! PicopackUpgrade call <SID>upgrade()

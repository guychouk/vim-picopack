" picopack.vim - Minimal package manager for Vim 8+
" Maintainer: guychouk
" License: Same terms as Vim itself (see :h license)

if exists('g:loaded_picopack')
  finish
endif
let g:loaded_picopack = 1

let s:path = get(g:, 'picopack_path', split(&packpath, ',')[0] . '/pack/bundle/start')

function! s:name(repo)
  return substitute(a:repo, '^.*/', '', '')
endfunction

function! s:echo(msg, hl)
  execute 'echohl' a:hl
  echo a:msg
  echohl None
endfunction

function! s:install()
  let packages = get(g:, 'picopack', [])
  if empty(packages)
    call s:echo('Nothing to install. Define packages in g:picopack', 'WarningMsg')
    return
  endif

  if !isdirectory(s:path)
    call mkdir(s:path, 'p')
  endif

  for repo in packages
    let name = s:name(repo)
    let dest = s:path . '/' . name

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

  call s:echo('Done!', 'MoreMsg')
endfunction

function! s:update()
  let packages = get(g:, 'picopack', [])
  if empty(packages)
    call s:echo('Nothing to update. Define packages in g:picopack', 'WarningMsg')
    return
  endif

  for repo in packages
    let name = s:name(repo)
    let dest = s:path . '/' . name

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

  call s:echo('Done!', 'MoreMsg')
endfunction

function! s:clean()
  let packages = get(g:, 'picopack', [])
  let installed = glob(s:path . '/*', 0, 1)
  let keep = map(copy(packages), 's:path . "/" . s:name(v:val)')

  for dir in installed
    if index(keep, dir) == -1
      let name = fnamemodify(dir, ':t')
      call s:echo('Removing ' . name . '...', 'WarningMsg')
      call delete(dir, 'rf')
    endif
  endfor

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

if exists('g:loaded_symlink') | finish | endif
let g:loaded_symlink = 1

function! s:resolve_path(path) abort
  " NOTE: getftype() is useless if the path is under a symbolic link directory.
  if !filereadable(a:path) | return | endif
  let resolved = resolve(a:path)
  if resolved ==# a:path | return | endif
  " NOTE: Set b:symlink_should_resolve_path to falsy not to resolve path.
  if !get(b:, 'symlink_should_resolve_path', 1) | return | endif
  let escaped = fnameescape(resolved)
  execute 'file' escaped
  " Refresh buffer to avoid the confirmation "Overwriting existing file...?"
  " on the first attempt to :write the resolved buffer.
  try
    edit
  catch /^Vim\%((\a\+)\)\=:E994/
    " if has('patch-8.1.1714') && !empty(&previewpopup), then
    " ignore E994: Not allowed in a popup window
  endtry
endfunction

augroup resolve_symlink
  " PERF: No need to clear the augroup because of g:loaded_symlink check.
  " PERF: To let users trigger callbacks on `BufFilePre` or `BufFilePost` for
  " resolved paths autocmd-nested would be necessary, but would not be worth
  " the performance cost and the maintainancebility.
  " NOTE: Prefer `%` to `<afile>`. When editing a file outside of current
  " working directory, autocmd pattern is matched against the resolved
  " fullpath; in other words, both <afile> and <amatch> have already been
  " resolved in autocmd, and the callback function would fail to tell if the
  " new buffer is on symbolic link.
  " Related to https://github.com/aymericbeaumet/vim-symlink/issues/13
  autocmd BufReadPost * call s:resolve_path(expand('%'))
augroup END

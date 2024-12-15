# vim-symlink

Another implementation to resolve symbolic link paths,
using `:file` instead of `:edit`.

## Features

- No `autocmd-nested` for **performance**.
- **Clean** buffer list without `:bwipeout`
  and [moll/vim-bbye](https://github.com/moll/vim-bbye).
- An option
  [`b:symlink_should_resolve_path`](#bsymlink_should_resolve_path)
  is provided to **exclude** arbitrary paths.

## Install

Install with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "aileot/vim-symlink" }
```

Install with [packer](https://github.com/wbthomason/packer.nvim):

```lua
use({ "aileot/vim-symlink" })
```

Install with [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'aileot/vim-symlink'
```

## Options

### `b:symlink_should_resolve_path`

_(default: `1`)_\
A buffer-local option.
If it is set to `0` or `v:false`
(or set `vim.b.symlink_should_resolve_path` to `false` in nvim),
path for the buffer will not be resolved.
This option is expected to be set on `BufReadPre`.

## Potential Issues

Due to the `:file` redirection, you could get confused in some autocmd events:

- The values for `autocmd-pattern`, `<amatch>`, and `<afile>`,
  to a symbolic link could be different from its **resolved** path,
  but the symbolic link one itself.

- The buffer name got by `bufname()` (and `nvim_buf_get_name()` in nvim)
  could be different from what you expect to the path,
  though the value of `<abuf>` for the resolved path
  is the same as the symbolic link one,

Please consider applying `resolve()` to `<amatch>` or `<afile>` as your needs.

## Acknowledgment

Implementation on `:file` has been discussed in
<https://github.com/tpope/vim-fugitive/issues/147>.

## Alternative

- [aymericbeaumet/vim-symlink](https://github.com/aymericbeaumet/vim-symlink)

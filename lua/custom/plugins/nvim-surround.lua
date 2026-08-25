-- Add, delete and change surrounding pairs: `ysiw)`, `ds"`, `cs'"`.
--
-- NOTE: kickstart also enables `mini.surround`, which uses the `sa`/`sd`/`sr`
--  prefixes, so the two coexist without clobbering each other's mappings.
vim.pack.add { 'https://github.com/kylechui/nvim-surround' }
require('nvim-surround').setup {}

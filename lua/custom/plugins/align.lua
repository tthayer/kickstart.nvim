-- Align text around a delimiter, e.g. `gaip=` aligns a paragraph on `=`.
vim.pack.add { 'https://github.com/junegunn/vim-easy-align' }

vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy[A]lign' })
vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy[A]lign' })

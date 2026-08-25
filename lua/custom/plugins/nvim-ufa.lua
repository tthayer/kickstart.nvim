-- Better folding, backed by LSP / treesitter fold information.
--  `promise-async` is a hard dependency of `nvim-ufo`.

-- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
-- auto-closing them after leaving insert mode, however ufo does not seem to
-- have equivalents for zr and zm because there is no saved fold level.
-- Consequently, the vim-internal fold levels need to be disabled by setting
-- them to 99. This must happen before any buffer is folded.
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.pack.add {
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
}

require('ufo').setup {
  provider_selector = function(_, ft, _)
    -- INFO some filetypes only allow indent, some only LSP, some only
    -- treesitter. However, ufo only accepts two kinds as priority,
    -- therefore making this function necessary :/
    local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python' }
    if vim.tbl_contains(lspWithOutFolding, ft) then return { 'treesitter', 'indent' } end
    return { 'lsp', 'indent' }
  end,
  -- when opening the buffer, close these fold kinds
  -- use `:UfoInspect` to get available fold kinds from the LSP
  close_fold_kinds_for_ft = {
    default = { 'imports', 'comment' },
  },
  open_fold_hl_timeout = 800,
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local hlgroup = 'NonText'
    local newVirtText = {}
    local suffix = '   ' .. tostring(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth) end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, hlgroup })
    return newVirtText
  end,
}

-- stylua: ignore start
vim.keymap.set('n', 'zm', function() require('ufo').closeAllFolds() end, { desc = '󱃄 Close All Folds' })
vim.keymap.set('n', 'zr', function() require('ufo').openFoldsExceptKinds { 'comment', 'imports' } end, { desc = '󱃄 Open All Regular Folds' })
vim.keymap.set('n', 'zR', function() require('ufo').openFoldsExceptKinds {} end, { desc = '󱃄 Open All Folds' })
vim.keymap.set('n', 'z1', function() require('ufo').closeFoldsWith(1) end, { desc = '󱃄 Close L1 Folds' })
vim.keymap.set('n', 'z2', function() require('ufo').closeFoldsWith(2) end, { desc = '󱃄 Close L2 Folds' })
vim.keymap.set('n', 'z3', function() require('ufo').closeFoldsWith(3) end, { desc = '󱃄 Close L3 Folds' })
vim.keymap.set('n', 'z4', function() require('ufo').closeFoldsWith(4) end, { desc = '󱃄 Close L4 Folds' })
-- stylua: ignore end

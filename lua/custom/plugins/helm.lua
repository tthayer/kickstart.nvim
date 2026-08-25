-- Helm template (gotmpl) filetype support.
vim.pack.add { 'https://github.com/towolf/vim-helm' }

-- `yamlls` chokes on Go template directives, so detach it from any yaml buffer
--  that contains `{{ ... }}` and let vim-helm handle the file instead.
local function detach_yamlls()
  for _, client in ipairs(vim.lsp.get_clients { name = 'yamlls' }) do
    vim.lsp.buf_detach_client(0, client.id)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('_gotmpl', { clear = true }),
  pattern = 'yaml',
  callback = function()
    vim.schedule(function()
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        if line:match '{{.+}}' then
          vim.defer_fn(detach_yamlls, 500)
          return
        end
      end
    end)
  end,
})

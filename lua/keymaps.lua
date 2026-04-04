-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>ts', function() vim.cmd 'set spell!' end, { desc = 'Toggle [s]pelling' })

vim.keymap.set('n', '<leader>tw', function()
  local buf = vim.api.nvim_get_current_buf()
  local wrap = vim.opt_local.wrap:get()

  if wrap then
    vim.opt_local.wrap = false
    -- intentionally leaving linbreak alone

    -- Restore normal movement by removing buffer-local maps
    pcall(vim.keymap.del, 'n', 'j', { buffer = buf })
    pcall(vim.keymap.del, 'n', 'k', { buffer = buf })
  else
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true

    -- Wrapped-line-friendly movement
    vim.keymap.set('n', 'j', 'gj', { buffer = buf, silent = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = buf, silent = true })
  end

  print("wrap '", vim.opt_local.wrap:get(), "'")
end, { desc = 'Toggle [w]rapping' })

vim.keymap.set('n', '<leader>tW', function()
  local fo = vim.bo.formatoptions

  if fo:find('t', 1, true) then
    vim.bo.formatoptions = fo:gsub('t', '')
    print 'disabled hardwrap'
  else
    vim.bo.formatoptions = fo .. 't'
    print 'enabled hardwrap'
  end
end, { desc = 'Toggle hard [W]rapping' })

vim.keymap.set('n', '<leader>tu', require('undotree').open, { desc = 'Toggle [u]ndotree' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Markdown format settings',
  pattern = 'markdown',
  callback = function()
    vim.opt_local.textwidth = 120
    vim.opt_local.colorcolumn = '+1'
    vim.opt_local.formatoptions:append 't'
    vim.opt_local.spell = true
  end,
})

-- vim: ts=2 sts=2 sw=2 et

return {
  {
    'stevearc/resession.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local resession = require 'resession'
      resession.setup {
        autosave = {
          enabled = true,
          interval = 60,
          notify = false,
        },
      }

      -- Keymaps
      vim.keymap.set('n', '<leader>Ss', resession.save, { desc = '[S]ession [S]ave' })
      vim.keymap.set('n', '<leader>Sl', resession.load, { desc = '[S]ession [L]oad' })
      vim.keymap.set('n', '<leader>Sd', resession.delete, { desc = '[S]ession [D]elete' })

      -- Or use the telescope picker instead of the default UI
      vim.keymap.set('n', '<leader>Sf', function()
        require('telescope').extensions.resession.resession(
          -- use existing theme
          require('telescope.themes').get_dropdown()
        )
      end, { desc = '[S]ession [F]ind' })

      -- Auto-save session on exit
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          -- Only load the session if nvim was started with no args and without reading from stdin
          if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { silence_errors = true })
          end
        end,
        nested = true,
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          resession.save(vim.fn.getcwd(), { notify = false })
        end,
      })

      vim.api.nvim_create_autocmd('StdinReadPre', {
        callback = function()
          -- Store this for later
          vim.g.using_stdin = true
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et

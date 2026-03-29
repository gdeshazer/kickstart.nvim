local function createSessionName()
  local home = vim.uv.os_homedir()
  local workingDir = vim.fn.getcwd()

  if home == nil then
    return workingDir
  end

  local start, en = string.find(workingDir, home, 1, true)

  if start == nil then
    return workingDir
  end

  return 'home::' .. string.sub(workingDir, en + 1, -1)
end

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
          -- don't create a session for the home directory
          if vim.uv.os_homedir() == vim.fn.getcwd() then
            return
          end

          -- Only load the session if nvim was started with no args and without reading from stdin
          if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
            -- Save these to a different directory, so our manual sessions don't get polluted
            local sessionName = createSessionName()
            resession.load(sessionName, { silence_errors = true })
          end
        end,
        nested = true,
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          -- don't create a session for the home directory
          if vim.uv.os_homedir() == vim.fn.getcwd() then
            return
          end

          if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
            resession.save(createSessionName(), { notify = false })
          end
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

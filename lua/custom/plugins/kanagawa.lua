return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      --@diagnostic disable-next-line: missing-fields
      require('kanagawa').setup {
        undercurl = true,
        terminalColors = true,
        commentStyle = { italic = false },
        overrides = function(colors)
          local theme = colors.theme

          return {
            SpellBad = { undercurl = true, sp = theme.diag.warning },
            SpellCap = { undercurl = true, sp = theme.diag.warning },
            SpellLocal = { undercurl = true, sp = theme.diag.warning },
            SpellRare = { undercurl = true, sp = theme.diag.warning },
          }
        end,
      }

      vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

-- extensions for conform
-- should automatically load formatters from mason and apply them to conform

-- todo: should probably come up with a different approach for this since mason-conform is archived
-- may not be required if we are always making sure to specify formatters/LSPs from config instead
-- of manually installing them through mason
return {
  { 'zapling/mason-conform.nvim' },
}

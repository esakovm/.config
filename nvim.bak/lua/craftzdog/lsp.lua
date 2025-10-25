local M = {}
local LazyvimUtil = require("lazyvim.util")

function M.toggleInlayHints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

return M

if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.ts,*.tsx",
	callback = function()
		-- Получаем текущие буфер и позицию курсора
		local bufnr = vim.api.nvim_get_current_buf()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		-- Формируем параметры для запроса code actions
		local params = {
			textDocument = vim.lsp.util.make_text_document_params(),
			context = {
				diagnostics = {},
				only = { "source.removeUnused" }, -- Исправленный идентификатор действия
			},
			range = {
				start = { line = 0, character = 0 },
				["end"] = { line = vim.fn.line("$") - 1, character = 0 },
			},
		}

		-- Синхронный запрос code actions
		local result = vim.lsp.buf_request_sync(
			bufnr,
			"textDocument/codeAction",
			params,
			1000 -- Таймаут 1 секунда
		)

		-- Применяем найденные actions
		if result and result[1] then
			local actions = result[1].result or {}
			for _, action in ipairs(actions) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
				end
				if action.command then
					vim.lsp.buf.execute_command(action.command)
				end
			end
		end

		-- Восстанавливаем позицию курсора
		vim.api.nvim_win_set_cursor(0, cursor_pos)
	end,
})
require("config.lazy")

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		local supported_filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"json",
			"jsonc",
		}

		local ft = vim.bo[args.buf].filetype
		if not vim.tbl_contains(supported_filetypes, ft) then
			return
		end

		local clients = vim.lsp.get_active_clients({ bufnr = args.buf, name = "biome" })
		if #clients == 0 then
			return
		end

		vim.lsp.buf.format({
			async = false,
			filter = function(client)
				return client.name == "biome"
			end,
		})
	end,
})

local function setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = {
			prefix = "?",
			spacing = 4,
			-- ?????????????? ??????? ?????????
			format = function(diagnostic)
				local max_width = math.floor(vim.o.columns * 0.6)
				local message = diagnostic.message:gsub("\n", " ")

				if #message > max_width then
					message = message:sub(1, max_width - 3) .. "..."
				end

				return string.format("%s [%s]", message, diagnostic.source)
			end,
		},
		float = {
			border = "rounded",
			wrap = true,
			max_width = 80,
			header = "",
			format = function(diagnostic)
				return string.format("%s\n\n[%s]", diagnostic.message, diagnostic.source)
			end,
		},
	})
end

setup_diagnostics()

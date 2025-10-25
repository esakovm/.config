return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"typescript-language-server",
				"css-lsp",
				"eslint-lsp",
				"prettier",
				"some-sass-language-server",
				"biome",
			})
		end,
	},

	-- null-ls для форматирования и линтинга
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "mason.nvim" },
		opts = function(_, opts)
			local null_ls = require("null-ls")

			-- Добавляем Biome в null-ls
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			opts.sources = {
				-- Форматирование Biome
				formatting.biome.with({
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"jsonc",
					},
					extra_args = { "--unsafe" }, -- если нужны опасные правки
				}),

				-- Диагностика Biome
				diagnostics.biome.with({
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"jsonc",
					},
				}),

				-- Другие форматтеры...
				formatting.stylua,
				formatting.shfmt,
				formatting.prettier.with({
					filetypes = { "html", "markdown", "css", "yaml", "yml" },
				}),
			}
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			---@type lspconfig.options
			servers = {
				-- ... остальные серверы остаются как были

				-- Настройка Biome LSP (только для диагностики)
				biome = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern("biome.json", "package.json", ".git")(...)
					end,
					single_file_support = true,
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"jsonc",
					},
					settings = {
						biome = {
							requireConfig = true,
						},
					},
				},

				-- Отключаем форматирование в tsserver, так как используем Biome
				tsserver = {
					-- ... остальные настройки tsserver
					on_attach = function(client)
						-- Отключаем форматирование в tsserver, чтобы использовать Biome
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				},
			},
		},
	},
}

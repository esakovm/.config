-- return {
-- 	{
-- 		"craftzdog/solarized-osaka.nvim",
-- 		lazy = true,
-- 		priority = 1000,
-- 		opts = function()
-- 			return {
-- 				transparent = true,
-- 			}
-- 		end,
-- 	},
-- }
return {
	{ "scottmckendry/cyberdream.nvim" },

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "cyberdream",
		},
	},
}

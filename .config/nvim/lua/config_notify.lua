local notify = require("mini.notify")

notify.setup({
	-- Content management
	content = {
		-- Function which formats the notification message
		-- By default prepends message with notification time
		format = nil,

		-- Function which orders notification array from most to least important
		-- By default orders first by level and then by update timestamp
		sort = nil,
	},

	-- Notifications about LSP progress
	lsp_progress = {
		-- Whether to enable showing
		enable = false,

		-- Duration (in ms) of how long last message should be shown
		duration_last = 1000,
	},

	-- Window options
	window = {
		-- Floating window config
		config = {
			border = "double",
			row = 2,
		},

		-- Value of 'winblend' option
		-- winblend = 25,
	},
})

local opts = {
	ERROR = { duration = 5000, hl_group = "DiagnosticError" },
	WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
	INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
	DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
	TRACE = { duration = 0, hl_group = "DiagnosticOk" },
	OFF = { duration = 0, hl_group = "MiniNotifyNormal" },
}

vim.notify = notify.make_notify(opts)

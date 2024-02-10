local fzflua = require("fzf-lua")
local actions = require("fzf-lua.actions")

fzflua.setup({
	buffers = {
		file_icons = true,
		color_icons = false,
	},
	diagnostics = {
		file_icons = true,
		color_icons = false,
		actions = {
			["ctrl-q"] = function(selected)
				print(vim.fn.split(selected[1], "\n")[2])
			end,
		},
	},
	grep = {
		actions = {
			["ctrl-q"] = {
				fn = actions.file_edit_or_qf,
				prefix = "select-all+",
			},
		},
	},
	files = {
		-- git_icons = false,
		file_icons = true,
		color_icons = false,
		fd_opts = "--color=always --type f --hidden --follow --exclude .git",
		actions = {
			["ctrl-q"] = {
				fn = actions.file_edit_or_qf,
				prefix = "select-all+",
			},
		},
	},
	fzf_opts = { ["--layout"] = "default", ["--marker"] = "+", ["--cycle"] = "" },
	winopts = {
		width = 0.9,
		height = 0.8,
		-- backdrop = 100,
		preview = {
			hidden = "nohidden",
			vertical = "up:30%",
			horizontal = "right:30%",
			layout = "horizontal",
			flip_columns = 120,
			delay = 10,
			winopts = { number = false },
		},
	},
	keymap = {
		builtin = {
			false, -- do not inherit from defaults
			-- ["<C-d>"] = "preview-half-page-down",
			-- ["<C-u>"] = "preview-half-page-up",
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
		},
	},
	-- actions = {
	-- 	files = {
	-- 		["ctrl-q"] = {
	-- 			fn = actions.file_edit_or_qf,
	-- 			prefix = "select-all+",
	-- 		},
	-- 	},
	-- 	grep = {
	-- 		["ctrl-q"] = {
	-- 			fn = actions.file_edit_or_qf,
	-- 			prefix = "select-all+",
	-- 		},
	-- 	},
	-- },
	fzf_colors = {
		-- values in 3rd+ index will be passed raw
		-- i.e:  `--color fg+:#010101:bold:underline`
		-- ["bg+"] = { "bg", "Normal" },
		-- ["bg+"] = { "bg", "Normal" },
		-- ["bg"] = { "bg", "Normal" },
		-- ["fg"] = { "fg", "Normal" },
		-- ["hl"] = { "hl", { "FzfLuaSearch" } },
		-- ["hl+"] = { "hl", { "FzfLuaSearch" } },
		-- It is also possible to pass raw values directly
		-- ["gutter"] = "-1",
	},
})

local function buffer_dir()
	return vim.fn.expand("%:p:h")
end

vim.keymap.set("n", "<leader>ft", function()
	fzflua.builtin()
end)

vim.keymap.set("n", "<leader>fcc", function()
	fzflua.files({ cwd = buffer_dir(), winopts = { preview = { layout = "horizontal" } } })
end)

-- vim.keymap.set("n", "<leader>ff", function()
-- 	fzflua.files()
-- end, { desc = "Find files in fzf" })

-- vim.keymap.set("n", "<leader><leader>ff", function()
-- 	-- local opts = vim.tbl_deep_extend("force", baseThemeOptions, { hidden = true })
-- 	-- builtin.find_files(opts)
-- 	fzflua.resume()
-- 	-- fzflua.files({ fzf_c:lors = true })
-- end, { desc = "Resume search in fzf" })

vim.keymap.set("n", "<leader>fgg", function()
	fzflua.grep({ search = "" })
end)

vim.keymap.set("n", "<leader>fgc", function()
	fzflua.grep({ search = "", cwd = buffer_dir() })
end)

vim.keymap.set("n", "<leader>fb", function()
	fzflua.buffers()
end)

vim.keymap.set("n", "<leader>fh", function()
	fzflua.help_tags()
end)

vim.keymap.set("n", "<leader>fe", function()
	fzflua.diagnostics_workspace({ winopts = { preview = { layout = "vertical" } } })
end)

vim.keymap.set("n", "<leader>fr", function()
	fzflua.lsp_references({ winopts = { preview = { layout = "vertical" } } })
end)

vim.keymap.set("n", "<leader>fd", function()
	fzflua.lsp_document_symbols({ winopts = { preview = { layout = "vertical" } } })
end)

vim.keymap.set("n", "<leader>fi", function()
	fzflua.git_branches({ winopts = { preview = { layout = "horizontal" } } })
end)

vim.keymap.set("n", "<leader>fs", function()
	fzflua.lsp_live_workspace_symbols({ winopts = { preview = { layout = "vertical" } } })
end)

vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
	vim.fn.feedkeys("zz", "m")
end, { silent = true })

local newLine = "\n"
local docBufr = -1
local docWin = -1
local docWinSize = 120

vim.keymap.set("n", "go", function()
	if docWin > 0 and vim.api.nvim_win_is_valid(docWin) then
		vim.api.nvim_win_close(docWin, true)
	end
end)

local function setContentInSplitWindow(ft, content)
	local enterWin = false

	if docBufr < 0 or not vim.api.nvim_buf_is_valid(docBufr) or not vim.api.nvim_buf_is_loaded(docBufr) then
		docBufr = vim.api.nvim_create_buf(false, false)
		-- vim.api.nvim_set_option_value("modifiable", false, { buf = docBufr })
		vim.api.nvim_set_option_value("ft", ft, { buf = docBufr })
		-- vim.api.nvim_buf_set_name(docBufr, "test.md")
	end

	vim.api.nvim_buf_set_lines(docBufr, 0, -1, false, content)

	if docWin < 0 or not vim.api.nvim_win_is_valid(docWin) then
		docWin = vim.api.nvim_open_win(docBufr, enterWin, { split = "right", width = docWinSize })
		vim.api.nvim_set_option_value("number", false, { scope = "local", win = docWin })
	end

	vim.api.nvim_win_set_buf(docWin, docBufr)
	vim.api.nvim_win_set_cursor(docWin, { 1, 0 })

	vim.api.nvim_buf_call(docBufr, function()
		if ft == "markdown" then
			-- vim.cmd([[ Markview enable ]])
		end
		vim.cmd([[ setlocal nonumber ]])
		-- vim.cmd([[ setlocal nomodifiable ]])
		-- vim.cmd([[ setlocal nobuflisted ]])
		-- vim.cmd([[ setlocal buftype nowrite ]])
	end)
end

local function splitWindowDoc(method, contentAndFtGetter)
	pcall(vim.lsp.buf_request, 0, method, vim.lsp.util.make_position_params(), function(err, response)
		if err ~= nil then
			vim.notify(err.message)
			return
		end

		local ok, content, ft = contentAndFtGetter(response)

		if not ok then
			return
		end

		setContentInSplitWindow(ft, content)
	end)
end

vim.keymap.set("n", "gh", function()
	splitWindowDoc("textDocument/hover", function(response)
		if response and response.contents and response.contents.kind and response.contents.value then
			local content = response.contents
			local ft = content.kind
			local docContent = vim.fn.split("# HOVER\n\n" .. content.value, newLine)

			return true, docContent, ft
		end

		return false, nil, nil
	end)
end, { desc = "Custom hover in split" })

local function fillDocumentationText(
	finalDoc,
	bufferFt,
	documentationContainers,
	containerName,
	isCompact,
	innerDocContainersGetter
)
	for index, documentationContainer in ipairs(documentationContainers) do
		local tableToInsert = finalDoc
		local tempDoc = {}

		if isCompact then
			tableToInsert = tempDoc
		end

		table.insert(tableToInsert, containerName .. " #" .. tostring(index))

		-- if not isCompact then
		-- 	table.insert(tableToInsert, "")
		-- end
		-- print(vim.inspect("st"))
		-- print(vim.inspect(documentationContainer.label))
		-- print(vim.inspect(type(documentationContainer.label)))
		-- print(vim.inspect("end"))
		if documentationContainer.label and type(documentationContainer.label) == "string" then
			if not isCompact then
				table.insert(tableToInsert, "```" .. bufferFt)
			end

			table.insert(tableToInsert, documentationContainer.label)

			if not isCompact then
				table.insert(tableToInsert, "```")
				-- table.insert(tableToInsert, "")
			end
		end

		local documentation = documentationContainer.documentation

		if documentation and documentation.value and documentation.value ~= "" then
			local kind = documentation.kind
			local isMdOrPlainText = kind and (kind == "markdown" or kind == "plaintext")

			if not isMdOrPlainText then
				table.insert(tableToInsert, "```" .. kind)
			end

			for _, line in ipairs(vim.fn.split(documentation.value, newLine)) do
				table.insert(tableToInsert, line)
			end

			if not isCompact then
				table.insert(tableToInsert, "")
			end

			if not isMdOrPlainText then
				table.insert(tableToInsert, "```")
			end
		end

		if isCompact then
			local message = table.concat(tempDoc, " ~ ")
			table.insert(finalDoc, message)
		end

		if innerDocContainersGetter then
			local innerDocumentationContainers, innerContainerName, innerContainerIsCompact =
				innerDocContainersGetter(documentationContainer)

			fillDocumentationText(
				finalDoc,
				bufferFt,
				innerDocumentationContainers,
				innerContainerName,
				innerContainerIsCompact
			)
		end
	end

	table.insert(finalDoc, "")
end

vim.keymap.set("n", "gk", function()
	splitWindowDoc("textDocument/signatureHelp", function(response)
		if not response then
			vim.notify("No signature")
			return false, nil, nil
		end

		local finalDoc = { "# SIGNATURES", "" }
		local ft = "markdown"
		local bufferFt = vim.api.nvim_get_option_value("filetype", {})

		-- print(vim.inspect(response))

		local signatures = response.signatures

		if not signatures then
			return false, nil, nil
		end

		table.insert(finalDoc, "_" .. tostring(#signatures) .. " Total Signature(s)_")
		table.insert(finalDoc, "")

		fillDocumentationText(finalDoc, bufferFt, signatures, "## Signature", false, function(container)
			return container.parameters, " > param", true
		end)

		return true, finalDoc, ft
	end)
end, { desc = "Custom signatures in split" })

vim.keymap.set("n", "gj", function()
	local ok, diag = pcall(vim.diagnostic.get_next)

	if ok and diag and diag.severity then
		local severity = vim.diagnostic.severity[diag.severity]
		local content = { "# DIAGNOSTICS", "", "* " .. severity .. " : " }
		for _, value in ipairs(vim.fn.split(diag.message, newLine)) do
			table.insert(content, value)
		end
		setContentInSplitWindow("markdown", content)
	end
end, { desc = "Custom signatures in split" })

vim.keymap.set("n", "gi", function()
	vim.lsp.buf.implementation()
	vim.fn.feedkeys("zz", "m")
end)

vim.keymap.set("n", "<leader>rr", function()
	vim.lsp.buf.rename()
end)

local function range_from_selection(bufnr, mode)
	-- TODO: Use `vim.fn.getregionpos()` instead.

	-- [bufnum, lnum, col, off]; both row and column 1-indexed
	local start = vim.fn.getpos("v")
	local end_ = vim.fn.getpos(".")
	local start_row = start[2]
	local start_col = start[3]
	local end_row = end_[2]
	local end_col = end_[3]

	-- A user can start visual selection at the end and move backwards
	-- Normalize the range to start < end
	if start_row == end_row and end_col < start_col then
		end_col, start_col = start_col, end_col
	elseif end_row < start_row then
		start_row, end_row = end_row, start_row
		start_col, end_col = end_col, start_col
	end
	if mode == "V" then
		start_col = 1
		local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
		end_col = #lines[1]
	end
	return {
		["start"] = { start_row, start_col - 1 },
		["end"] = { end_row, end_col - 1 },
	}
end

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	-- splitWindowDoc("textDocument/codeAction", function(response)
	-- 	print(vim.inspect(response))
	-- 	return true, "etn"
	-- end)
	--
	-- local action = "textDocument/codeAction"
	-- local client = vim.lsp.get_clients({ bufnr = 0, method = action })[1]
	-- local context = {}
	-- local params
	-- -- params = vim.lsp.util.make_range_params(0, client.offset_encoding)
	-- -- print(vim.inspect(params))
	--
	-- local range = range_from_selection(0, "V")
	-- params = vim.lsp.util.make_given_range_params(range.start, range["end"], 0, client.offset_encoding)
	-- params.context = context
	--
	-- if not context.triggerKind then
	-- 	context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
	-- end
	--
	-- if not context.diagnostics then
	-- 	local bufnr = vim.api.nvim_get_current_buf()
	-- 	-- context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
	-- end
	--
	-- pcall(vim.lsp.buf_request, 0, "textDocument/codeAction", params, function(err, response)
	-- 	if err ~= nil then
	-- 		print(vim.inspect(err))
	-- 		-- vim.notify(err.message)
	-- 		return
	-- 	end
	--
	-- 	print(vim.inspect(response))
	-- end)

	-- vim.lsp.buf.code_action(opts?)
	-- local t = ""
	fzflua.lsp_code_actions()
end)

local function getTasks(cb)
	local task_cmd = { "task", "export" }

	local result = {}

	vim.system(task_cmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local json = vim.fn.json_decode(obj.stdout)

				table.sort(json, function(a, b)
					return a.urgency > b.urgency
				end)

				table.insert(result, "# Tasks")
				table.insert(result, "")

				vim.iter(json)
					:filter(function(t)
						return t.status == "pending"
					end)
					:map(function(t)
						return string.format(
							"* [ ] [P%s] - *%s* - %s",
							t.urgency,
							-- t.id,
							t.project,
							t.description
						)
					end)
					:each(function(t)
						table.insert(result, t)
					end)

				cb(result)
			end
		end)
	end)
end

vim.keymap.set("n", "<leader>nt", function()
	getTasks(function(content)
		setContentInSplitWindow("markdown", content)
	end)
end, {
	desc = "Toggle task list",
})

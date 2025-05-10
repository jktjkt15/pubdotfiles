-- JayReplace Mode
local lastSpot = {}
local isVisual = false

local function saveCurrentSpot()
	lastSpot = vim.api.nvim_win_get_cursor(0)
end

local function restoreSavedSpot()
	isVisual = false
	pcall(vim.api.nvim_win_set_cursor, 0, lastSpot)
end

local function getRegularRange()
	return {
		starting = vim.api.nvim_buf_get_mark(0, "["),
		ending = vim.api.nvim_buf_get_mark(0, "]"),
	}
end

local function getPasteRegisterContent()
	return vim.fn.getreg("+", true, true)
end

local function setTextFromRegularRange(contentToPaste)
	local range = getRegularRange()

	vim.api.nvim_buf_set_text(
		0,
		range.starting[1] - 1,
		range.starting[2],
		range.ending[1] - 1,
		range.ending[2] + 1,
		contentToPaste
	)
end

local function setTextFromLineRange(contentToPaste)
	local pos = vim.fn.getpos(".")

	vim.api.nvim_buf_set_lines(0, pos[2] - 1, pos[2], true, contentToPaste)
end

local function setEndOfLineTextFromLineRange(contentToPaste)
	local pos = vim.fn.getpos(".")

	vim.api.nvim_buf_set_text(0, pos[2] - 1, pos[3] - 1, pos[2] - 1, -1, contentToPaste)
end

local function setTextVisualLineRange(contentToPaste)
	local range = {
		starting = vim.fn.line("'<") - 1,
		ending = vim.fn.line("'>"),
	}

	vim.api.nvim_buf_set_lines(0, range.starting, range.ending, true, contentToPaste)
end

function _G.__JayReplace(motion)
	if motion == nil then
		saveCurrentSpot()
		isVisual = vim.api.nvim_get_mode().mode == "V"
		vim.o.operatorfunc = "v:lua.__JayReplace"
		return "g@"
	end

	local contentToPaste = getPasteRegisterContent()

	if isVisual then
		setTextVisualLineRange(contentToPaste)
	else
		setTextFromRegularRange(contentToPaste)
	end

	restoreSavedSpot()
end

function _G.__JayReplaceLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayReplaceLine"
		return "g@l"
	end

	local contentToPaste = getPasteRegisterContent()

	setTextFromLineRange(contentToPaste)

	restoreSavedSpot()
end

function _G.__JayReplaceEndOfLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayReplaceEndOfLine"
		return "g@l"
	end

	local contentToPaste = getPasteRegisterContent()

	setEndOfLineTextFromLineRange(contentToPaste)

	restoreSavedSpot()
end

function _G.__JaySSHYank(motion)
	if motion == nil then
		saveCurrentSpot()
		isVisual = vim.api.nvim_get_mode().mode == "V"
		vim.o.operatorfunc = "v:lua.__JaySSHYank"
		return "g@"
	end

	local text = nil

	if isVisual then
		local range = {
			starting = vim.fn.line("'<") - 1,
			ending = vim.fn.line("'>"),
		}

		text = vim.api.nvim_buf_get_lines(0, range.starting, range.ending, true)
	else
		local range = {
			starting = vim.api.nvim_buf_get_mark(0, "["),
			ending = vim.api.nvim_buf_get_mark(0, "]"),
		}

		text = vim.api.nvim_buf_get_text(
			0,
			range.starting[1] - 1,
			range.starting[2],
			range.ending[1] - 1,
			range.ending[2] + 1,
			{}
		)
	end

	vim.notify("yup: " .. vim.inspect(text))
	require("vim.ui.clipboard.osc52").copy("+")(text)

	restoreSavedSpot()
end

function _G.__JayYank(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayYank"
		return "g@"
	end

	local range = {
		starting = vim.api.nvim_buf_get_mark(0, "["),
		ending = vim.api.nvim_buf_get_mark(0, "]"),
	}

	local text = vim.api.nvim_buf_get_text(
		0,
		range.starting[1] - 1,
		range.starting[2],
		range.ending[1] - 1,
		range.ending[2] + 1,
		{}
	)

	vim.fn.setreg("+", text)

	restoreSavedSpot()
end

function _G.__JayYankLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayYankLine"
		return "g@l"
	end

	local pos = vim.fn.getpos(".")

	local lines = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], true)

	vim.fn.setreg("+", lines)

	restoreSavedSpot()
end

function _G.__JayYankEndOfLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayYankEndOfLine"
		return "g@l"
	end

	local pos = vim.fn.getpos(".")

	local endOfLine = vim.api.nvim_buf_get_text(0, pos[2] - 1, pos[3] - 1, pos[2] - 1, -1, {})

	vim.fn.setreg("+", endOfLine[1])

	restoreSavedSpot()
end

function _G.__JayCut(motion)
	if motion == nil then
		saveCurrentSpot()
		isVisual = vim.api.nvim_get_mode().mode == "V"
		vim.o.operatorfunc = "v:lua.__JayCut"
		return "g@"
	end

	local text = nil

	if isVisual then
		local range = {
			starting = vim.fn.line("'<") - 1,
			ending = vim.fn.line("'>"),
		}

		text = vim.api.nvim_buf_get_lines(0, range.starting, range.ending, true)

		vim.api.nvim_buf_set_lines(0, range.starting, range.ending, true, {})
	else
		local range = {
			starting = vim.api.nvim_buf_get_mark(0, "["),
			ending = vim.api.nvim_buf_get_mark(0, "]"),
		}

		text = vim.api.nvim_buf_get_text(
			0,
			range.starting[1] - 1,
			range.starting[2],
			range.ending[1] - 1,
			range.ending[2] + 1,
			{}
		)

		vim.api.nvim_buf_set_text(
			0,
			range.starting[1] - 1,
			range.starting[2],
			range.ending[1] - 1,
			range.ending[2] + 1,
			{}
		)
	end

	vim.fn.setreg("+", text)

	restoreSavedSpot()
end

function _G.__JayCutLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayCutLine"
		return "g@l"
	end

	local pos = vim.fn.getpos(".")

	local lines = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], true)

	vim.fn.setreg("+", lines)

	vim.api.nvim_buf_set_lines(0, pos[2] - 1, pos[2], true, {})

	restoreSavedSpot()
end

function _G.__JayCutEndOfLine(motion)
	if motion == nil then
		saveCurrentSpot()
		vim.o.operatorfunc = "v:lua.__JayCutEndOfLine"
		return "g@l"
	end

	local pos = vim.fn.getpos(".")

	local endOfLine = vim.api.nvim_buf_get_text(0, pos[2] - 1, pos[3] - 1, pos[2] - 1, -1, {})
	vim.fn.setreg("+", endOfLine)

	vim.api.nvim_buf_set_text(0, pos[2] - 1, pos[3] - 1, pos[2] - 1, -1, {})

	restoreSavedSpot()
end

vim.keymap.set("x", "p", "r", { remap = true, desc = "Visual paste without saving deleted word" })
-- vim.keymap.set("n", "p", "a<CR><Esc>P<Up>JJ", { desc = "Normal paste" })
vim.keymap.set("n", "q", "r", { remap = false, desc = "Replace one letter" })

vim.keymap.set("n", "rr", _G.__JayReplaceLine, { expr = true, desc = "Replace current line" })
vim.keymap.set({ "n", "v" }, "r", _G.__JayReplace, { expr = true, desc = "Replace operator" })
vim.keymap.set("n", "R", _G.__JayReplaceEndOfLine, { expr = true, desc = "Replace until the end of the line" })
vim.keymap.set("n", "yy", _G.__JayYankLine, { expr = true, remap = false })
vim.keymap.set("n", "y", _G.__JayYank, { expr = true })
vim.keymap.set("n", "Y", _G.__JayYankEndOfLine, { expr = true })
vim.keymap.set("n", "mm", _G.__JayCutLine, { expr = true, remap = false, desc = "Cut current line" })
vim.keymap.set({ "n", "v" }, "m", _G.__JayCut, { expr = true, desc = "Cut operator" })
vim.keymap.set("n", "M", _G.__JayCutEndOfLine, { expr = true, desc = "Cut until the end of the line" })

vim.keymap.set({ "n", "x" }, "d", '"_d', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n" }, "dd", '"_dd', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "D", '"_D', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "x", '"_x', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "X", '"_X', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "c", '"_c', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n" }, "cc", '"_cc', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "C", '"_C', { remap = false, desc = "Blackhole delete" })
vim.keymap.set({ "n", "x" }, "S", "<nop>", { remap = false, desc = "Blackhole delete" })

-- 1 rintirsen dei
-- 2 rintirsen jkl
-- 3 rintirsen mno pqr

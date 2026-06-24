require("nvim-surround").setup()

vim.g.nvim_surround_no_normal_mappings = true
vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)")
vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)")
vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)")
vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)")
-- vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)")

-- "bababa"
-- keymaps = {
--     insert = "<C-g>s",
--     insert_line = "<C-g>S",
--     normal = "ys",
--     normal_cur = "yss",
--     normal_line = "yS",
--     normal_cur_line = "ySS",
--     visual = nil,
--     visual_line = nil,
--     delete = "ds",
--     change = "cs",
--     change_line = "cS",
-- }

vim.cmd[[set indentkeys-=:]]
local py = "python3"
if vim.fn.has("win32") == 1 then
  py = "python"
end
local cmd = py .. " %"
cmd = ":sp | terminal " .. cmd
vim.keymap.set("n", "<leader>p", cmd)
vim.keymap.set("v", "<leader>p", ":w !" .. py)

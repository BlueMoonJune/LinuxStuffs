
local txt = win(nvim.get_current_win())
vim.cmd("32vsplit")
local files = win(nvim.get_current_win())
local fbuf = buf(nvim.create_buf(true, true))
files:set_buf(fbuf)
nvim.set_current_win(txt.v)

fbuf:set_lines(0, 1, false, {"woah"})


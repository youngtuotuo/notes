local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
local headers = require('tuo.ascii').ascii_art

local space = '<space>'

local function button(usr_opts, txt, leader_txt, keybind, keybind_opts)
  local sc_after = usr_opts.shortcut:gsub('%s', ''):gsub(leader_txt, '<leader>')

  local default_opts = {
    position = 'center',
    cursor = 5,
    width = 50,
    align_shortcut = 'right',
    hl_shortcut = 'Keyword'
  }
  local opts = vim.tbl_deep_extend('force', default_opts, usr_opts)

  if nil == keybind then
    keybind = sc_after
  end
  keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
  opts.keymap = { 'n', sc_after, keybind, keybind_opts }

  local function on_press()
    -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
    local key = vim.api.nvim_replace_termcodes(sc_after .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

math.randomseed(os.time())
dashboard.section.header.val = headers[math.random(1, #headers)]

dashboard.section.buttons.val= {
  button({shortcut = 'c', hl = {{'IconColor3', 2, 3}}}, '  Configurations', space, '<cmd>e ~/.config/nvim/<CR>'),
  button({shortcut = 's', hl = {{'IconColor2', 2, 3}}}, 'ﮣ  PackerSync' , space, '<cmd>PackerSync<CR>'),
  button({shortcut = 'pc', hl = {{'IconColor2', 2, 3}}}, 'ﮣ  PackerCompile' , space, '<cmd>PackerSync<CR>'),
  button({shortcut = 'pp', hl = {{'IconColor3', 2, 3}}}, 'ﮣ  PackerProfile', space, '<cmd>PackerProfile<CR>'),
  button({shortcut = 'ps', hl = {{'IconColor3', 2, 3}}}, 'ﮣ  PackerStatus', space, '<cmd>PackerStatus<CR>'),
  button({shortcut = space .. ' e', hl = {{'IconColor5', 2, 3}}}, '  Find files', space, '<cmd>Telescope find_files<CR>'),
  button({shortcut = space .. ' l', hl = {{'IconColor7', 2, 3}}}, 'ﭨ  Live grep', space, '<cmd>Telescope live_grep<CR>'),
  button({shortcut = 'q', hl = {{'IconColor8', 2, 3}}}, '  Quit' , space, '<cmd>qa<CR>')
}

-- Footer must be a table so that its height is correctly measured
local num_plugins_loaded = #vim.fn.globpath(vim.fn.stdpath('data') .. '/site/pack/packer/start', '*', 0, 1)
local num_plugins_tot = #vim.tbl_keys(packer_plugins)
if num_plugins_tot <= 1 then
  dashboard.section.footer.val = { num_plugins_loaded .. ' / ' .. num_plugins_tot .. ' plugin ﮣ loaded' }
else
  dashboard.section.footer.val = { num_plugins_loaded .. ' / ' .. num_plugins_tot.. ' plugins ﮣ loaded' }
end
dashboard.section.footer.opts.hl = 'Comment'


-- Set paddings
local h_header = #dashboard.section.header.val
local h_buttons = #dashboard.section.buttons.val * 2 - 1
local h_footer = #dashboard.section.footer.val
local pad_tot = vim.o.lines - (h_header + h_buttons + h_footer)
local pad_1 = math.ceil(pad_tot * 0.25)
local pad_2 = math.ceil(pad_tot * 0.20)
local pad_3 = math.floor(pad_tot * 0.30)

dashboard.config.layout = {
  { type = 'padding', val = pad_1 },
  dashboard.section.header,
  { type = 'padding', val = pad_2 },
  dashboard.section.buttons,
  { type = 'padding', val = pad_3 },
  dashboard.section.footer
}

-- Do not show statusline or tabline in alpha buffer
vim.cmd [[ au User AlphaReady if winnr('$') == 1 | set laststatus=0 showtabline=0 | endif | au BufUnload <buffer> set laststatus=3 showtabline=2 ]]

alpha.setup(dashboard.opts)

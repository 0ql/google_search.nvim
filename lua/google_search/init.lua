local Popup = require("nui.popup")
local Input = require("nui.input")
local Layout = require("nui.layout")

local Search = Popup:extend("Search")

function Search:init(popup_options)
	local options = vim.tbl_deep_extend("force", popup_options or {}, {
		border = "rounded",
		focusable = true,
		position = { row = 0, col = "100%" },
		size = { width = 10, height = 1 },
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
		line = 0,
		options = {}
	})

	Search.super.init(self, options)
end

function Search:items(options)
	self.options = options
	vim.defer_fn(function()
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, self.options)
	end, 0)
end

-- Credit where credit is due
-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

local function urlencode(url)
	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

local function submit(value)
	io.popen("xdg-open https://google.com/search?q=" .. urlencode(value))
end

local function google_search()
	local input_options = {
		focusable = true,
		position = { row = 0, col = "100%" },
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
		size = 20,
		border = {
			style = "rounded",
			text = {
				top = " Google Search ",
				top_align = "center",
			},
		},
	}

	local search = Search()

	local input = Input(input_options, {
		prompt = " ",
		on_submit = submit,
		on_change = function(value)
			local co = coroutine.create(function()
				if value == '' then return end
				local handle = io.popen("curl -s 'https://google.com/complete/search?output=firefox&q=" ..
					urlencode(value)
					.. "'")
				local result = handle:read("*a")
				local options = {}
				for hit in string.gmatch(result, "\"([^,\n\t:]+)\"") do
					table.insert(options, hit)
				end
				search:items(options)
			end)
			coroutine.resume(co)
		end
		,
	})

	search:map("n", "<Esc>", function()
		search:unmount()
	end)
	search:map("n", "<S-Tab>", function()
		vim.api.nvim_set_current_win(input.winid)
	end)
	search:map("n", "<CR>", function()
		local linenr = vim.api.nvim_win_get_cursor(search.winid)[1]
		local target = search.options[linenr]
		submit(target)
	end)

	input:map("i", "<Tab>", function()
		vim.api.nvim_set_current_win(search.winid)
	end, { noremap = true })
	input:map("i", "<Esc>", function()
		input:unmount()
	end, { noremap = true })

	local layout = Layout(
		{
			relative = "editor",
			position = "50%",
			size = {
				width = 80,
				height = "60%",
			},
		},
		Layout.Box({
			Layout.Box(input, { size = {
				width = "100%",
				height = "3"
			} }),
			Layout.Box(search, { size = "100%" }),
		}, { dir = "col" })
	)

	layout:mount()

	vim.api.nvim_set_current_win(input.winid)
end

return google_search

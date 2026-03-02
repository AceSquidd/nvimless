-- LEADERS
vim.g.mapleader = " "
vim.g.maplocalleader = " "



-- ============================================================================
-- OPTIONS
-- ============================================================================

-- scroll
vim.o.scrolloff = 8
vim.o.sidescrolloff = 12
vim.o.wrap = false

-- visuals
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "100"
vim.o.showmatch = true
vim.o.matchtime = 2
vim.o.cmdheight = 2
vim.o.showmode = false
vim.o.winborder = "rounded"

-- tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4


-- meta
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.autoread = true

vim.opt.iskeyword:append("-")

-- search
vim.o.smartcase = true
vim.o.incsearch = true

--clipboard
vim.o.clipboard = "unnamedplus"

-- folding settings
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99

-- split behavior
vim.o.splitbelow = true
vim.o.splitright = true

-- command-line completion
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })



-- ============================================================================
-- KEYMAPS Generals
-- ============================================================================

local map = vim.keymap.set

-- Quicks
map('n', '<leader>o', ':update<CR> :source<CR>', { desc = "Save and Source" })
map("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
map("n", "<leader>ff", ":find ", { desc = "Find file" })
-- Clear Highlights
map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Center screen when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer navigation
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Format
map('n', '<leader>lf', vim.lsp.buf.format, { desc = "Format with LSP" })

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick config editing
map("n", "<leader>rc", ":e $LOCALAPPDATA/nvim/init.lua<CR>", { desc = "Edit config" })





-- ============================================================================
-- USEFUL FUNCTIONS
-- ============================================================================

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})





-- ============================================================================
-- PLUGINS --
-- ============================================================================

vim.pack.add({
	-- CLSCHEME
	{ src = "https://github.com/neanias/everforest-nvim" },
	-- MASON-LSP
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
	-- VIMTEX
	{ src = "https://github.com/lervag/vimtex" },
	-- LUASNIP
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})





-- ============================================================================
-- LSP
-- ============================================================================

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- REQUIRES

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"texlab",
	}
})



-- ============================================================================
-- LATEX FORMATTING
-- ============================================================================


function _G.format_latex_clean()
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- run latexindent silently
  vim.fn.system('latexindent -r -w -l ".latexindent.yaml" ' .. vim.fn.expand('%:p'))
  -- reload buffer
  vim.cmd('edit!')
  vim.api.nvim_win_set_cursor(0, cursor)
end

vim.api.nvim_set_keymap('n', '<leader>f', ':lua format_latex_clean()<CR>', { noremap = true, silent = true })




----------------------------------------- COLORSCHEME ---------------------------------------------
vim.cmd("colorscheme retrobox")

------------------------------------------- SNIPPETS ----------------------------------------------
local ls = require("luasnip")

-- Load Snippets

ls.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
ls.config.set_config({
  enable_autosnippets = true,
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

-- keybinds

-- supertabs

map({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
      "n",
      true
    )
  end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })


map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

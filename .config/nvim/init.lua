-- {{{ Preflight requirements
local lazy = require('lazy-wrapper')
-- }}}

--  {{{ TODO: Functions (move to separated file)
local state = {
  terminal_buf = nil,
  terminal_job = nil,
}

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function remember_terminal(buf)
  if not is_valid_buf(buf) or vim.bo[buf].buftype ~= 'terminal' then
    return
  end

  local job_id = vim.b[buf].terminal_job_id
  if job_id then
    state.terminal_buf = buf
    state.terminal_job = job_id
  end
end

local function find_terminal_job()
  -- Prefer remembered/last active terminal.
  if is_valid_buf(state.terminal_buf) and state.terminal_job then
    return state.terminal_job, state.terminal_buf
  end

  -- Then prefer visible terminal windows.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' and vim.b[buf].terminal_job_id then
      remember_terminal(buf)
      return state.terminal_job, state.terminal_buf
    end
  end

  -- Fallback: any terminal buffer.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' and vim.b[buf].terminal_job_id then
      remember_terminal(buf)
      return state.terminal_job, state.terminal_buf
    end
  end

  return nil, nil
end

local function ensure_terminal()
  local job_id, buf = find_terminal_job()
  if job_id then
    return job_id, buf
  end

  vim.cmd('belowright 10split')
  vim.cmd('terminal')
  buf = vim.api.nvim_get_current_buf()
  remember_terminal(buf)
  vim.cmd('wincmd p')

  return state.terminal_job, state.terminal_buf
end

local function send_to_terminal(text)
  local job_id = ensure_terminal()
  if not job_id then
    vim.notify('No terminal job found', vim.log.levels.ERROR)
    return
  end

  vim.fn.chansend(job_id, text .. '\n')
end

local function run_current_line()
  send_to_terminal(vim.api.nvim_get_current_line())
end

local function run_visual_selection()
  local mode = vim.fn.visualmode()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local srow, scol = start_pos[2], start_pos[3]
  local erow, ecol = end_pos[2], end_pos[3]

  if srow > erow or (srow == erow and scol > ecol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end

  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  if #lines == 0 then
    return
  end

  if mode == 'v' then
    lines[#lines] = string.sub(lines[#lines], 1, ecol)
    lines[1] = string.sub(lines[1], scol)
  end

  send_to_terminal(table.concat(lines, '\n'))
end

local function kubectl_apply_current_file()
  vim.cmd('write')
  local file = vim.fn.shellescape(vim.fn.expand('%:p'))
  send_to_terminal('kubectl apply -f ' .. file)
end

local function smart_delete_buffer(force)
  local buf = vim.api.nvim_get_current_buf()
  local wins = vim.fn.win_findbuf(buf)

  -- Terminal buffers often look alive even after the shell is done. Delete them explicitly.
  if vim.bo[buf].buftype == 'terminal' then
    vim.cmd((force and 'bdelete! ' or 'bdelete ') .. buf)
    return
  end

  if vim.bo[buf].modified and not force then
    vim.notify('Buffer has unsaved changes: use <leader>bD to force close', vim.log.levels.WARN)
    return
  end

  if #wins > 1 then
    vim.cmd('close')
  else
    vim.cmd((force and 'bdelete! ' or 'bdelete ') .. buf)
  end
end
--  }}}

-- {{{ Configuration
-- {{{ VIM
vim.opt.autoindent = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.breakindent = true
vim.opt.cc = '80'
vim.opt.completeopt = 'longest,menu,preview'
vim.opt.cuc = true
vim.opt.cul = true
vim.opt.expandtab = true
vim.opt.encoding = 'UTF-8'
vim.opt.foldcolumn = 'auto'
vim.opt.foldmethod = 'marker'
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.lazyredraw = true
vim.opt.listchars = { tab = '>-', lead = '.', multispace = '-+', trail = '!' }
vim.opt.list = true
vim.opt.mouse = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.spelllang = 'en_us,ru,lv'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.synmaxcol = 150
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wildmode = 'longest,list'
vim.opt.wrap = true

vim.g.mapleader = '\\'
vim.g['spellfile_URL'] = 'https://ftp.pl.vim.org/pub/vim/runtime/spell'
-- }}}

-- {{{ NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- }}}

-- {{{ Lazy
lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}
-- }}}
-- }}}

-- {{{ Initialization
lazy.setup({
    {
        'nvim-tree/nvim-tree.lua',
        init = function()
            require('nvim-tree').setup()
        end,
    },
    { 'ashfinal/vim-colors-paper' },
    { 'haishanh/night-owl.vim' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            {
                'nvim-tree/nvim-web-devicons',
                init = function()
                    require('nvim-web-devicons').setup()
                end,
            },
        },
        init = function()
            paste_func = function()
                if vim.opt.paste:get() then
                    return '<P>'
                end

                return ''
            end

            require('lualine').setup({
                options = {
                    theme = 'jellybeans',
                    disabled_filetypes = { 'packer', 'NvimTree' }
                },
                sections = {
                    lualine_a = {
                        {
                            'mode',
                            fmt = function(str) return str:sub(1,1) end,
                        },
                        {
                            paste_func,
                        },
                    },
                },
            })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    { 'dhruvasagar/vim-zoom' },
    { 'ludovicchabant/vim-gutentags' },
    {
        'm4xshen/autoclose.nvim',
        init = function()
            require('autoclose').setup()
        end,
    },
    { 'towolf/vim-helm', lazy = true, },
    { 'Glench/Vim-Jinja2-Syntax', },
    { 'mustache/vim-mustache-handlebars', },
    { 'tpope/vim-fugitive' },
    { 'vim-scripts/dbext.vim' },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod', lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true},
            { 'vim-scripts/dbext.vim' },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            vim.g.db_uo_use_nerd_fonts = 1
        end,
    },
    { 'ctrlpvim/ctrlp.vim' },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        init = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'kotlin' },
                auto_install = false,
                sync_install = false,
                ignore_install = {},
                modules = {},
                indent = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
            { 'j-hui/fidget.nvim', opts = {} },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        init = function()
            require('mason').setup()

            require('mason-tool-installer').setup({
                ensure_installed = {
                    'basedpyright',
                    'ruff',
                    'ktlint',
                },
            })

            local cap = require('cmp_nvim_lsp').default_capabilities()
            cap.general = cap.general or {}
            cap.general.positionEncodings = { 'utf-16' }

            vim.lsp.config('basedpyright', {
                capabilities = cap,
            })

            vim.lsp.config('ruff', {
                capabilities = cap,
            })

            vim.lsp.enable({
                'basedpyright',
                'ruff',
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        init = function()
            local cmp = require('cmp')

            cmp.setup({
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'buffer', keyword_length = 3 },
                }),
            })
        end,
    },
})
vim.cmd.colorscheme('paper')
-- }}}

-- {{{ Bindings
local tb = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', tb.find_files)
vim.keymap.set('n', '<leader>fg', tb.live_grep)
vim.keymap.set('n', '<leader>fb', tb.buffers)
vim.keymap.set('n', 'gr', tb.lsp_references)
vim.keymap.set('n', 'gd', tb.lsp_definitions)
vim.keymap.set('n', 'gi', tb.lsp_implementations)
vim.keymap.set('n', '<leader>ds', tb.lsp_document_symbols)
vim.keymap.set('n', '<leader>dd', tb.diagnostics)

vim.keymap.set({'n'}, '<C-p>', ':CtrlPBuffer<cr>')
vim.keymap.set({'n'}, '<F1>', ':NvimTreeToggle<cr>')
vim.keymap.set({'n'}, '<F2>', function()
  vim.cmd('belowright 10split')
  vim.cmd('terminal')
  remember_terminal(vim.api.nvim_get_current_buf())
end, { desc = 'Open terminal split' })
vim.keymap.set({'n'}, '<F3>', ':DBUIToggle<cr>')
vim.keymap.set({'n'}, '<Tab>', '<C-W><C-W>')
vim.keymap.set({'n'}, '<Leader>g', ':G<cr>')
vim.keymap.set({'n'}, '<Leader>p', ':set paste!<cr>')
vim.keymap.set({'n'}, '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set({'n'}, '<leader>rt', run_current_line, { desc = 'Run current line in terminal' })
vim.keymap.set({'n'}, '<leader>bd', function() smart_delete_buffer(false) end, { desc = 'Delete buffer' })
vim.keymap.set({'n'}, '<leader>bD', function() smart_delete_buffer(true) end, { desc = 'Force delete buffer' })
vim.keymap.set({'i'}, '<Leader>p', '<C-O>:set paste!<cr>')
vim.keymap.set({'t'}, '<C-Space>', '<C-\\><C-N>')
vim.keymap.set({'n'}, '<Leader>nt', ':tabnew<cr>:term<cr>')
vim.keymap.set({'n'}, '<Leader>nd', ':tabnew<cr>:DBUIToggle<cr>')
vim.keymap.set({'n'}, '<leader>ka', kubectl_apply_current_file, { desc = 'kubectl apply current file' })

vim.keymap.set({'v'}, '<leader>rt', run_visual_selection, { desc = 'Run selection in terminal' })
-- }}}

-- {{{ Autocmd
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter', 'WinEnter' }, {
  callback = function(args)
    remember_terminal(args.buf)
  end,
})

-- {{{ Cleanup trailing spaces
vim.api.nvim_create_autocmd(
	{ 'BufWritePre' },
	{
		pattern = { '*' },
		command = [[ %s/\s\+$//e ]],
	}
)
-- }}}
-- }}}

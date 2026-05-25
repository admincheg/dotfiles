-- {{{ Preflight requirements
local lazy = require('lazy-wrapper')
-- }}}

--  {{{ TODO: Functions (move to separated file)
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
vim.keymap.set({'n'}, '<F2>', ':below term<cr>10<C-W>_')
vim.keymap.set({'n'}, '<F3>', ':DBUIToggle<cr>')
vim.keymap.set({'n'}, '<Tab>', '<C-W><C-W>')
vim.keymap.set({'n'}, '<Leader>g', ':G<cr>')
vim.keymap.set({'n'}, '<Leader>p', ':set paste!<cr>')
vim.keymap.set({'n'}, '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set({'i'}, '<Leader>p', '<C-O>:set paste!<cr>')
vim.keymap.set({'t'}, '<C-Space>', '<C-\\><C-N>')
-- }}}

-- {{{ Autocmd
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

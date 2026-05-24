-- title
vim.o.titlestring = ""
vim.o.title = false

-- options ------------------------------------------------------------------------------------------------------------
-- :%s/foo/bar/ 显示替换到预览中
vim.o.inccommand = "split"

-- 浮动窗增加边框圆角(易阅读)
vim.o.winborder = "rounded"

-- 关闭交换文件
vim.o.swapfile = true

local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = true

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 默认新窗口位置
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 自动注释
-- opt.formatoptions:remove({ "o", "r" })


-- 高亮括号
opt.showmatch = true

-- 关闭在命令行不断显示模式切换的文字
-- 有时想保留前次操作的文字记录
-- opt.showmode = false

-- 自动重加载外部变更
opt.autoread = true

-- 关闭buffer显示
opt.hidden = true

-- (-)被连接的单词被视为一个单词
opt.iskeyword:append("-") -- in-the-world

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

-- fold
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99

-- 统一自动补全方案(保证显示一致性)
-- menuone, 只有一项时,也会显示菜单
-- noinsert,`实时`将文本返馈到代码里,易误触,加入后,候选窗内容需确认后才上屏
-- noselect, 不会预选第一项
opt.completeopt = "menuone,noselect,preinsert"
vim.g.autocomplete = true


-- 超过120个字符的标尺
opt.colorcolumn = "120"

-- 居中
-- opt.scrolloff = 999
opt.scrolloff = 10

-- keymap -------------------------------------------------------------------------------------------------------------
local keymap = vim.keymap
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--insert mode--
keymap.set("i", "kj", "<ESC>")

-- 行移动
keymap.set("n", "<C-c><C-n>", "<cmd>m .+1<CR>==", { desc = "move line down" })
keymap.set("n", "<C-c><C-p>", "<cmd>m .-2<CR>==", { desc = "move line up" })
--
-- 块状移动 --
keymap.set("v", "<C-c><C-n>", "<cmd>m '>+1<CR>gv=gv", { desc = "move block down" })
keymap.set("v", "<C-c><C-p>", "<cmd>m '<-2<CR>gv=gv", { desc = "move block up" })

-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clean highlight match" })

-- vim 特有的数值(+/-)
keymap.set("n", "<leader>a", "<C-a>", { desc = "number increase" })
keymap.set("n", "<leader>x", "<C-x>", { desc = "number decrease" })

-- 一些emacs小快捷键一致性
keymap.set('n', '<C-e>', '$')
keymap.set('i', '<C-e>', '<C-o>$')

keymap.set('n', '<C-a>', '0')
keymap.set('i', '<C-a>', '<C-o>^')

keymap.set({ 'i', 'n' }, '<C-l>', 'zz')
keymap.set('i', '<C-d>', '<Delete>')

-- 保存并格式化
keymap.set({ 'i', 'n' }, '<C-x><C-s>', function()
    vim.lsp.buf.format()
    vim.cmd("stopinsert")
    vim.cmd("write")
end, { desc = "save file" })

-- buffer 切换
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "buffer next" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "buffer previous" })

-- 显示推导信息
keymap.set("n", "<leader>ih", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle Inlay Hints" })

-- autocmd ------------------------------------------------------------------------------------------------------------
-- 复制时高亮着色
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup,
    callback = function()
        vim.hl.on_yank()
    end
})


-- colorscheme --------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/Shatur/neovim-ayu",
})
local function packadd(name)    -- packadd 本地函数
    vim.cmd("packadd " .. name) -- packadd 是 vim 的命令
end
-- colorscheme
packadd("neovim-ayu")
vim.cmd.colorscheme("ayu-dark")

-- nvim-web-devicons---------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-mini/mini.icons",
})
packadd("nvim-web-devicons")
packadd("mini.icons")

-- nvim-tree ----------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/nvim-tree/nvim-tree.lua",
})
packadd("nvim-tree.lua")
require("nvim-tree").setup({
    view = {
        width = 35,
    },
    filters = {
        dotfiles = true,
        exclude = { ".gitignore" },
    },
    renderer = {
        group_empty = true,
    },

})
keymap.set("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle()
end, { desc = "nvim tree open" })

-- lualine ------------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/nvim-lualine/lualine.nvim",
})
packadd("lualine.nvim")
require("lualine").setup({
    options = {
        section_separators = '',
        component_separators = '',
        theme = 'onedark',
    },
    extensions = { "nvim-tree" },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(str)
                    local map = {
                        normal = "n",
                        insert = "i",
                        visual = "v",
                        ["v-line"] = "vl",
                        ["v-block"] = "vb",
                        command = "c",
                        replace = "r",
                        terminal = "t",
                    }
                    return map[str] or str:sub(1, 1)
                end,
            },
        },
        lualine_c = { {
            'filename',
            file_status = true,
            newfile_status = false,
            path = 3,
        } },
        lualine_x = { "filesize", { "encoding", show_bomb = true }, "filetype" },
        lualine_y = {
            {
                'lsp_status',
                icon = '', -- f013
                symbols = {
                    -- Standard unicode symbols to cycle through for LSP progress:
                    spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                    -- Standard unicode symbol for when LSP is done:
                    done = '✓',
                    -- Delimiter inserted between LSP names:
                    separator = ' ',
                },
                -- List of LSP names to ignore (e.g., `null-ls`):
                ignore_lsp = {},
                -- Display the LSP name
                show_name = true,
            }
        },
    },
})

-- fzf-lua (use skim)--------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/ibhagwan/fzf-lua",
})
packadd("fzf-lua")
require("fzf-lua").setup({
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    fzf_bin = "sk",
})
keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, { desc = "fzf files" })
keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep()
end, { desc = "fzf live grep" })
keymap.set("n", "<leader>fb", function()
    require("fzf-lua").buffers()
end, { desc = "fzf buffers" })
keymap.set("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
end, { desc = "fzf help tags" })
keymap.set("n", "<leader>fx", function()
    require("fzf-lua").diagnostics_document()
end, { desc = "fzf diagnostics document" })
keymap.set("n", "<leader>fX", function()
    require("fzf-lua").diagnostics_workspace()
end, { desc = "fzf diagnostics workspace" })


-- nvim-treesitter-----------------------------------------------------------------------------------------------------
vim.pack.add({
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate"
    },
})
packadd("nvim-treesitter")
local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})
    local ensure_installed = {
        "vim",
        "rust",
        "c",
        "lua",
        "json",
        "bash",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "toml",
    }
    local config = require("nvim-treesitter.config")
    local already_installed = config.get_installed()
    local parsers_to_install = {}
    for _, parser in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, parser) then
            table.insert(parsers_to_install, parser)
        end
    end
    if #parsers_to_install > 0 then
        treesitter.install(parsers_to_install)
    end

    local group = vim.api.nvim_create_augroup("TreeSittterConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
                vim.treesitter.start(args.buf)
            end
        end
    })
end
setup_treesitter()


-- LSP, Linting, Formatting & Completion ------------------------------------------------------------------------------
vim.pack.add({
    -- Language Server Protocols
    "https://github.com/neovim/nvim-lspconfig",
    -- "https://github.com/mason-org/mason.nvim",
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.*"),
    },
})
packadd("nvim-lspconfig")
-- packadd("mason.nvim")
-- require("mason").setup({})

local diagnostic_signs = {
    Error = " ",
    Warn = " ",
    Hint = "",
    Info = "",
}

vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
            [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
            [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        max_width = 120,
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
        style = "minimal",
    },
})

do
    local orig = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig(contents, syntax, opts, ...)
    end
end

local function lsp_on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
        return
    end

    local bufnr = ev.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }


    opts.desc = "LSP [vim] Definition"
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

    opts.desc = "LSP [split] Definition"
    vim.keymap.set("n", "<leader>gS", function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
    end, opts)

    -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    opts.desc = "LSP Rename"
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "<leader>D", function()
        vim.diagnostic.open_float({ scope = "line" })
    end, opts)

    vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float({ scope = "cursor" })
    end, opts)

    opts.desc = "LSP Jump diagnostic"
    vim.keymap.set("n", "<leader>nd", function()
        vim.diagnostic.jump({ count = 1 })
    end, opts)

    vim.keymap.set("n", "<leader>pd", function()
        vim.diagnostic.jump({ count = -1 })
    end, opts)

    opts.desc = "LSP Hover"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "LSP Definitions"
    vim.keymap.set("n", "<leader>fd", function()
        require("fzf-lua").lsp_definitions({ jump1 = true })
    end, opts)

    opts.desc = "LSP Reference"
    vim.keymap.set("n", "<leader>fr", function()
        require("fzf-lua").lsp_references()
    end, opts)

    opts.desc = "LSP Type defs"
    vim.keymap.set("n", "<leader>ft", function()
        require("fzf-lua").lsp_typedefs()
    end, opts)

    opts.desc = "LSP document symbol"
    vim.keymap.set("n", "<leader>fs", function()
        require("fzf-lua").lsp_document_symbols()
    end, opts)

    opts.desc = "LSP LSP Workspace symbol"
    vim.keymap.set("n", "<leader>fw", function()
        require("fzf-lua").lsp_workspace_symbols()
    end, opts)

    opts.desc = "LSP Implementations"
    vim.keymap.set("n", "<leader>fi", function()
        require("fzf-lua").lsp_implementations()
    end, opts)

    if client:supports_method("textDocument/codeAction", bufnr) then
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true,
                bufnr = bufnr,
            })
            vim.defer_fn(function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end, 50)
        end, opts)
    end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.lsp.config["*"] = {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    cmd = { "/Users/byronzr/.cargo/bin/rust-analyzer" },
    filetypes = {"rs"},
    settings = {
        ["rust-analyzer"] = {
            lens = {
                debug = {
                    enable = true
                },
                enable = true,
                implementations = {
                    enable = true
                },
                references = {
                    adt = {
                        enable = true
                    },
                    enumVariant = {
                        enable = true
                    },
                    method = {
                        enable = true
                    },
                    trait = {
                        enable = true
                    }
                },
                run = {
                    enable = true
                },
                updateTest = {
                    enable = true
                }
            }
        }
    }
})

vim.lsp.config("taplo", {
    cmd = { "/opt/homebrew/bin/taplo", "lsp", "stdio" },
    filetypes = {"toml"},
})

vim.lsp.enable({
    "taplo",
    "lua_ls",
    "rust_analyzer",
})

-- blink.cmp-----------------------------------------------------------------------------------------------------------
vim.pack.add({
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.*"),
    },
})
require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        menu = { auto_show = true },

        -- Disable auto brackets
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = { auto_brackets = { enabled = false }, },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "buffer", "snippets" } },
    -- TODO: 下面某个设置,让使用习惯不顺畅
    -- snippets = {
    --     expand = function(snippet)
    --         require("luasnip").lsp_expand(snippet)
    --     end,
    -- },
    fuzzy = {
        implementation = "prefer_rust",
        prebuilt_binaries = { download = true },
    },
})


-- oil.nvim------------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/stevearc/oil.nvim",
})
packadd("oil.nvim")
require("oil").setup({})

-- flash---------------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/folke/flash.nvim",
})
packadd("flash.nvim")
require("flash").setup({
    label = {
        min_pattern_length = 2,
    },
    -- keys = {
    --     { "<C-.>", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --     { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --     { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --     { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --     { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    -- },
})

keymap.set("n", "<C-.>", function()
    require("flash").jump()
end)


-- neogit--------------------------------------------------------------------------------------------------------------
vim.pack.add({
    -- neogit
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/sindrets/diffview.nvim",
})
packadd("neogit")
require("neogit").setup({
    cmd = "Neogit",
    status = {
        recent_commit_count = 100,
    }
})
keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>")


-- which-key-----------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/folke/which-key.nvim",
})
packadd("which-key.nvim")
keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = true })
end)

-- autoppairs----------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/windwp/nvim-autopairs",
})
local npairs = require("nvim-autopairs")
npairs.setup({
    fast_wrap = {},
})


-- nvim-surround ------------------------------------------------------------------------------------------------------
vim.pack.add({ {
    src = "https://github.com/kylechui/nvim-surround",
    version = vim.version.range("4.x"), -- Use for stability; omit to use `main` branch for the latest features
} })
-- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
-- require("nvim-surround").setup({
--     -- Put your configuration here
-- })

-- kulala(rest client)-------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/mistweaverco/kulala.nvim"
})
packadd("kulala.nvim")
require("kulala").setup({
    global_keymaps = true
})

vim.api.nvim_set_hl(0, "MyTodo", { fg = "#ffcc00", bold = true })
vim.fn.matchadd("MyTodo", [[\v<(TODO|FIXME|NOTE|HACK):]])

-- animate.cursor------------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/sphamba/smear-cursor.nvim",
})
packadd("smear-cursor.nvim")
require('smear_cursor').setup({
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,

    -- Smear cursor when moving within line or to neighbor lines.
    -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
    smear_between_neighbor_lines = true,

    -- Draw the smear in buffer space instead of screen space when scrolling
    scroll_buffer_space = true,

    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears and particles will look a lot less blocky.
    legacy_computing_symbols_support = false,

    -- Smear cursor in insert mode.
    -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
    smear_insert_mode = true,
})

-- mini.indentscope ---------------------------------------------------------------------------------------------------
vim.pack.add({
    "https://github.com/nvim-mini/mini.indentscope"
})
packadd("mini.indentscope")
require("mini.indentscope").setup(
-- No need to copy this inside `setup()`. Will be used automatically.
    {
        -- Draw options
        draw = {
            -- Delay (in ms) between event and start of drawing scope indicator
            delay = 100,

            -- Animation rule for scope's first drawing. A function which, given
            -- next and total step numbers, returns wait time (in ms). See
            -- |MiniIndentscope.gen_animation| for builtin options. To disable
            -- animation, use `require('mini.indentscope').gen_animation.none()`.
            -- animation = --<function: implements constant 19ms between steps>,

            -- Whether to auto draw scope: return `true` to draw, `false` otherwise.
            -- Default draws only fully computed scope (see `options.n_lines`).
            -- predicate = function(scope) return not scope.body.is_incomplete end,

            -- Symbol priority. Increase to display on top of more symbols.
            priority = 2,
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            -- Textobjects
            object_scope = 'ii',
            object_scope_with_border = 'ai',

            -- Motions (jump to respective border line; if not present - body line)
            goto_top = '[i',
            goto_bottom = ']i',
        },

        -- Options which control scope computation
        options = {
            -- Type of scope's border: which line(s) with smaller indent to
            -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
            border = 'both',

            -- Whether to use cursor column when computing reference indent.
            -- Useful to see incremental scopes with horizontal cursor movements.
            indent_at_cursor = true,

            -- Maximum number of lines above or below within which scope is computed
            n_lines = 10000,

            -- Whether to first check input line to be a border of adjacent scope.
            -- Use it if you want to place cursor on function header to get scope of
            -- its body.
            try_as_border = false,
        },

        -- Which character to use for drawing scope indicator
        symbol = '╎',
    })

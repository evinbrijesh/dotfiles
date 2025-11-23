-- Core LSP configuration
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    -----------------------------------------------------------------------
    -- Imports
    -----------------------------------------------------------------------
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_cap = require("cmp_nvim_lsp").default_capabilities()
    local keymap = vim.keymap -- shorthand

    -----------------------------------------------------------------------
    -- Buffer‑local keymaps when an LSP server attaches
    -----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        keymap.set(
          "n",
          "gR",
          "<cmd>Telescope lsp_references<CR>",
          vim.tbl_extend("force", opts, { desc = "References" })
        )
        keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Declaration" }))
        keymap.set(
          "n",
          "gd",
          "<cmd>Telescope lsp_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Definition" })
        )
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          vim.tbl_extend("force", opts, { desc = "Implementation" })
        )
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Type‑Def" })
        )

        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code Action" })
        )
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))

        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          vim.tbl_extend("force", opts, { desc = "File Diagnostics" })
        )
        keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Line Diagnostics" })
        )
        keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev Diagnostic" }))
        keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))

        keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Doc" }))
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      end,
    })

    -----------------------------------------------------------------------
    -- Modern diagnostic sign configuration  (replaces sign_define loop)
    -----------------------------------------------------------------------
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
        },
      },
    })

    -----------------------------------------------------------------------
    -- 1) Give every Mason‑installed server the standard setup
    -----------------------------------------------------------------------
    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
      lspconfig[server].setup({ capabilities = cmp_cap })
    end

    -----------------------------------------------------------------------
    -- 2) Per‑server overrides (what your old setup_handlers did)
    -----------------------------------------------------------------------

    -- Svelte ▸ notify TS/JS change events so diagnostics stay in sync
    lspconfig.svelte.setup({
      capabilities = cmp_cap,
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- GraphQL ▸ make it run inside JSX/Svelte files as well
    lspconfig.graphql.setup({
      capabilities = cmp_cap,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- Emmet ▸ enable inside all the usual front‑end filetypes
    lspconfig.emmet_ls.setup({
      capabilities = cmp_cap,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
    })

    -- Lua ▸ tell lua‑ls about the global `vim`
    lspconfig.lua_ls.setup({
      capabilities = cmp_cap,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })
  end,
}
